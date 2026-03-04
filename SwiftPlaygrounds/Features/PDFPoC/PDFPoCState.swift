import Foundation
import Observation
import PDFKit

let samplePDFURL: URL = .init(string: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")!

enum PDFPoCResultKind: String {
    case idle
    case running
    case success
    case failure
}

struct PDFPoCResult: Equatable {
    let kind: PDFPoCResultKind
    let message: String

    static func idle(_ message: String) -> Self {
        .init(kind: .idle, message: message)
    }

    static func running(_ message: String) -> Self {
        .init(kind: .running, message: message)
    }

    static func success(_ message: String) -> Self {
        .init(kind: .success, message: message)
    }

    static func failure(_ message: String) -> Self {
        .init(kind: .failure, message: message)
    }
}

enum PDFPoCFlow: String {
    case reachability = "Reachability"
    case external = "External"
    case preview = "Preview"
    case download = "Download"
    case wkWebView = "WKWebView"
    case proceed = "Proceed"
}

enum PDFPoCError: LocalizedError {
    case nonHTTPResponse(flow: PDFPoCFlow)
    case httpStatus(flow: PDFPoCFlow, statusCode: Int, contentType: String?)
    case unsupportedContentType(flow: PDFPoCFlow, contentType: String?)
    case invalidPDFData
    case fileOperationFailed(message: String)
    case transport(flow: PDFPoCFlow, description: String)

    var errorDescription: String? {
        switch self {
        case let .nonHTTPResponse(flow):
            return "\(flow.rawValue) failed: response was not HTTP."
        case let .httpStatus(flow, statusCode, contentType):
            let contentTypeDescription = contentType ?? "unknown"
            return "\(flow.rawValue) failed: HTTP \(statusCode), content-type \(contentTypeDescription)."
        case let .unsupportedContentType(flow, contentType):
            let contentTypeDescription = contentType ?? "missing"
            return "\(flow.rawValue) failed: expected PDF content-type, got \(contentTypeDescription)."
        case .invalidPDFData:
            return "Unable to create PDFDocument from downloaded data."
        case let .fileOperationFailed(message):
            return message
        case let .transport(flow, description):
            return "\(flow.rawValue) failed: \(description)"
        }
    }
}

@MainActor
@Observable final class PDFPoCState {
    var isReachabilityRequired = false

    var isCheckingReachability = false
    var isLoadingPreview = false
    var isDownloading = false

    var isPresentingPreview = false
    var isPresentingShareSheet = false
    var isPresentingWKWebView = false

    var reachabilityResult: PDFPoCResult = .idle("Not checked yet.")
    var proceedResult: PDFPoCResult = .idle("Waiting for user action.")
    var externalOpenResult: PDFPoCResult = .idle("No external open attempt yet.")
    var previewResult: PDFPoCResult = .idle("No in-app preview attempt yet.")
    var downloadResult: PDFPoCResult = .idle("No download attempt yet.")
    var wkWebViewResult: PDFPoCResult = .idle("No WKWebView attempt yet.")

    var previewDocument: PDFDocument?
    var downloadedFileURL: URL?

    @ObservationIgnored private let fileManager = FileManager.default
    @ObservationIgnored private let session = URLSession.shared

    var canProceed: Bool {
        !isReachabilityRequired || reachabilityResult.kind == .success
    }

    var downloadedFilePath: String? {
        downloadedFileURL?.path
    }

    func prepareExternalOpenAttempt() {
        let message = "Requesting external app handoff for \(samplePDFURL.absoluteString)."
        externalOpenResult = .running(message)
        log(.external, message)
    }

    func completeExternalOpen(accepted: Bool) {
        let message: String
        if accepted {
            message = "System accepted the external open request."
            externalOpenResult = .success(message)
        } else {
            message = "System declined the external open request."
            externalOpenResult = .failure(message)
        }
        log(.external, message)
    }

    func checkReachability() async {
        guard !isCheckingReachability else {
            return
        }

        isCheckingReachability = true
        reachabilityResult = .running("Checking PDF reachability...")
        proceedResult = .idle("Waiting for user action.")
        log(.reachability, "Starting reachability check for \(samplePDFURL.absoluteString)")

        defer {
            isCheckingReachability = false
        }

        do {
            let message = try await performReachabilityCheck()
            reachabilityResult = .success(message)
            log(.reachability, message)
        } catch {
            let message = errorMessage(for: error, flow: .reachability)
            reachabilityResult = .failure(message)
            log(.reachability, message)
        }
    }

    func simulateProceed() {
        guard canProceed else {
            let message = "Proceed blocked until reachability succeeds."
            proceedResult = .failure(message)
            log(.proceed, message)
            return
        }

        let message: String
        if isReachabilityRequired {
            message = "Proceed allowed after reachability success."
        } else {
            message = "Proceed allowed without reachability gating."
        }

        proceedResult = .success(message)
        log(.proceed, message)
    }

    func previewPDFInApp() async {
        guard !isLoadingPreview else {
            return
        }

        isLoadingPreview = true
        isPresentingPreview = false
        previewDocument = nil
        previewResult = .running("Downloading PDF for in-app preview...")
        log(.preview, "Starting in-app preview load from \(samplePDFURL.absoluteString)")

        defer {
            isLoadingPreview = false
        }

        do {
            let (data, response) = try await session.data(from: samplePDFURL)
            let httpResponse = try validatedHTTPResponse(
                response,
                flow: .preview,
                requiresPDFContentType: false
            )

            guard let document = PDFDocument(data: data) else {
                throw PDFPoCError.invalidPDFData
            }

            previewDocument = document
            isPresentingPreview = true

            let message = "Preview ready (\(responseSummary(for: httpResponse)))."
            previewResult = .success(message)
            log(.preview, message)
        } catch {
            let message = errorMessage(for: error, flow: .preview)
            previewResult = .failure(message)
            log(.preview, message)
        }
    }

    func dismissPreview() {
        isPresentingPreview = false
        previewDocument = nil
        log(.preview, "Preview sheet dismissed.")
    }

    func downloadPDF() async {
        guard !isDownloading else {
            return
        }

        isDownloading = true
        isPresentingShareSheet = false
        downloadedFileURL = nil
        downloadResult = .running("Downloading PDF to a temporary file...")
        log(.download, "Starting download from \(samplePDFURL.absoluteString)")

        defer {
            isDownloading = false
        }

        do {
            let (temporaryFileURL, response) = try await session.download(from: samplePDFURL)
            let httpResponse = try validatedHTTPResponse(
                response,
                flow: .download,
                requiresPDFContentType: false
            )
            let destinationURL = try persistDownloadedFile(from: temporaryFileURL)
            downloadedFileURL = destinationURL

            let message = "Download succeeded (\(responseSummary(for: httpResponse)))."
            downloadResult = .success(message)
            log(.download, "\(message) Local path: \(destinationURL.path)")
        } catch {
            let message = errorMessage(for: error, flow: .download)
            downloadResult = .failure(message)
            log(.download, message)
        }
    }

    func presentShareSheet() {
        guard let downloadedFileURL else {
            let message = "Share sheet unavailable: download a file first."
            downloadResult = .failure(message)
            log(.download, message)
            return
        }

        isPresentingShareSheet = true
        log(.download, "Presenting share sheet for \(downloadedFileURL.path)")
    }

    func dismissShareSheet() {
        isPresentingShareSheet = false
        log(.download, "Share sheet dismissed.")
    }

    func presentWKWebView() {
        isPresentingWKWebView = true
        wkWebViewResult = .running("WKWebView sheet presented. Waiting for navigation events...")
        log(.wkWebView, "Presenting WKWebView for \(samplePDFURL.absoluteString)")
    }

    func dismissWKWebView() {
        isPresentingWKWebView = false
        log(.wkWebView, "WKWebView sheet dismissed.")
    }

    func recordWKWebViewEvent(_ event: String, error: Error? = nil) {
        if let error {
            let message = "\(event): \(error.localizedDescription)"
            wkWebViewResult = .failure(message)
            log(.wkWebView, message)
            return
        }

        let kind: PDFPoCResultKind
        switch event {
        case "didFinish":
            kind = .success
        case "didStartProvisionalNavigation", "didCommit":
            kind = .running
        default:
            kind = .idle
        }

        let message = "WKWebView \(event)"
        wkWebViewResult = .init(kind: kind, message: message)
        log(.wkWebView, message)
    }

    private func performReachabilityCheck() async throws -> String {
        var headRequest = URLRequest(url: samplePDFURL)
        headRequest.httpMethod = "HEAD"
        headRequest.cachePolicy = .reloadIgnoringLocalCacheData
        headRequest.timeoutInterval = 30

        let (_, headResponse) = try await session.data(for: headRequest)
        let headHTTPResponse = try httpResponse(from: headResponse, flow: .reachability)
        let headSummary = responseSummary(for: headHTTPResponse)
        log(.reachability, "HEAD response: \(headSummary)")

        if headHTTPResponse.statusCode == 405 {
            return try await performReachabilityFallback(
                reason: "HEAD returned 405. Falling back to GET."
            )
        }

        guard (200...299).contains(headHTTPResponse.statusCode) else {
            throw PDFPoCError.httpStatus(
                flow: .reachability,
                statusCode: headHTTPResponse.statusCode,
                contentType: contentType(from: headHTTPResponse)
            )
        }

        guard isPDFContentType(contentType(from: headHTTPResponse)) else {
            return try await performReachabilityFallback(
                reason: "HEAD did not confirm a PDF content-type. Falling back to GET."
            )
        }

        return "Reachable via HEAD (\(headSummary))."
    }

    private func performReachabilityFallback(reason: String) async throws -> String {
        log(.reachability, reason)

        let (_, response) = try await session.data(from: samplePDFURL)
        let httpResponse = try validatedHTTPResponse(
            response,
            flow: .reachability,
            requiresPDFContentType: true
        )

        return "Reachable via GET (\(responseSummary(for: httpResponse)))."
    }

    private func persistDownloadedFile(from temporaryFileURL: URL) throws -> URL {
        let destinationURL = fileManager.temporaryDirectory.appending(path: "pdf-poc-sample.pdf")

        if fileManager.fileExists(atPath: destinationURL.path) {
            do {
                try fileManager.removeItem(at: destinationURL)
            } catch {
                throw PDFPoCError.fileOperationFailed(
                    message: "Unable to replace existing temp file: \(error.localizedDescription)"
                )
            }
        }

        do {
            try fileManager.moveItem(at: temporaryFileURL, to: destinationURL)
        } catch {
            throw PDFPoCError.fileOperationFailed(
                message: "Unable to store downloaded file: \(error.localizedDescription)"
            )
        }

        return destinationURL
    }

    private func httpResponse(from response: URLResponse, flow: PDFPoCFlow) throws -> HTTPURLResponse {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw PDFPoCError.nonHTTPResponse(flow: flow)
        }

        return httpResponse
    }

    private func validatedHTTPResponse(
        _ response: URLResponse,
        flow: PDFPoCFlow,
        requiresPDFContentType: Bool
    ) throws -> HTTPURLResponse {
        let httpResponse = try httpResponse(from: response, flow: flow)

        guard (200...299).contains(httpResponse.statusCode) else {
            throw PDFPoCError.httpStatus(
                flow: flow,
                statusCode: httpResponse.statusCode,
                contentType: contentType(from: httpResponse)
            )
        }

        if requiresPDFContentType && !isPDFContentType(contentType(from: httpResponse)) {
            throw PDFPoCError.unsupportedContentType(
                flow: flow,
                contentType: contentType(from: httpResponse)
            )
        }

        return httpResponse
    }

    private func contentType(from httpResponse: HTTPURLResponse) -> String? {
        httpResponse.value(forHTTPHeaderField: "Content-Type")?.lowercased()
    }

    private func isPDFContentType(_ contentType: String?) -> Bool {
        guard let contentType else {
            return false
        }

        return contentType.contains("pdf")
    }

    private func responseSummary(for httpResponse: HTTPURLResponse) -> String {
        let contentTypeDescription = contentType(from: httpResponse) ?? "unknown"
        return "HTTP \(httpResponse.statusCode), content-type \(contentTypeDescription)"
    }

    private func errorMessage(for error: Error, flow: PDFPoCFlow) -> String {
        if let pdfError = error as? PDFPoCError, let errorDescription = pdfError.errorDescription {
            return errorDescription
        }

        return PDFPoCError.transport(
            flow: flow,
            description: error.localizedDescription
        ).errorDescription ?? error.localizedDescription
    }

    private func log(_ flow: PDFPoCFlow, _ message: String) {
        print("[PDFPoC][\(flow.rawValue)] \(message)")
    }
}
