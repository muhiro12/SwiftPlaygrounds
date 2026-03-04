import SwiftUI

struct PDFPoCView: View {
    @Environment(\.openURL) private var openURL
    @State private var state = PDFPoCState()

    var body: some View {
        Form {
            Section("Setup") {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sample PDF URL")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(samplePDFURL.absoluteString)
                        .font(.caption.monospaced())
                        .textSelection(.enabled)
                }

                Toggle(
                    "Require PDF reachable before proceeding",
                    isOn: isReachabilityRequiredBinding
                )

                Button("Check Reachability") {
                    Task {
                        await state.checkReachability()
                    }
                }
                .disabled(state.isCheckingReachability)

                PDFPoCStatusView(
                    title: "Reachability",
                    result: state.reachabilityResult
                )

                Button("Simulated Next") {
                    state.simulateProceed()
                }
                .disabled(!state.canProceed)

                PDFPoCStatusView(
                    title: "Proceed",
                    result: state.proceedResult
                )
            }

            Section("External Open") {
                Button("Open PDF in External App") {
                    state.prepareExternalOpenAttempt()
                    openURL(samplePDFURL) { accepted in
                        state.completeExternalOpen(accepted: accepted)
                    }
                }

                PDFPoCStatusView(
                    title: "Last Result",
                    result: state.externalOpenResult
                )
            }

            Section("In-App View") {
                Button("Preview PDF In-App") {
                    Task {
                        await state.previewPDFInApp()
                    }
                }
                .disabled(state.isLoadingPreview)
                .sheet(isPresented: previewPresentationBinding) {
                    NavigationStack {
                        Group {
                            if let previewDocument = state.previewDocument {
                                PDFKitView(document: previewDocument)
                            } else {
                                ContentUnavailableView(
                                    "No PDF Available",
                                    systemImage: "doc.richtext",
                                    description: Text("Preview the sample PDF again.")
                                )
                            }
                        }
                        .navigationTitle("PDF Preview")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    state.dismissPreview()
                                }
                            }
                        }
                    }
                }

                PDFPoCStatusView(
                    title: "Last Result",
                    result: state.previewResult
                )
            }

            Section("Download") {
                Button("Download PDF") {
                    Task {
                        await state.downloadPDF()
                    }
                }
                .disabled(state.isDownloading)

                PDFPoCStatusView(
                    title: "Last Result",
                    result: state.downloadResult
                )

                if let downloadedFilePath = state.downloadedFilePath {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Local Temp File")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        Text(downloadedFilePath)
                            .font(.caption.monospaced())
                            .textSelection(.enabled)
                    }
                }

                if let downloadedFileURL = state.downloadedFileURL {
                    Button("Share / Save to Files") {
                        state.presentShareSheet()
                    }
                    .sheet(isPresented: shareSheetPresentationBinding) {
                        ActivityViewControllerRepresentable(activityItems: [downloadedFileURL])
                    }
                }
            }

            Section("WKWebView") {
                Button("Open PDF in WKWebView") {
                    state.presentWKWebView()
                }
                .sheet(isPresented: wkWebViewPresentationBinding) {
                    NavigationStack {
                        PDFPoCWKWebView(url: samplePDFURL) { event, error in
                            state.recordWKWebViewEvent(event, error: error)
                        }
                        .navigationTitle("WKWebView")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    state.dismissWKWebView()
                                }
                            }
                        }
                    }
                }

                PDFPoCStatusView(
                    title: "Last Result",
                    result: state.wkWebViewResult
                )
            }
        }
        .navigationTitle("PDF PoC")
    }

    private var isReachabilityRequiredBinding: Binding<Bool> {
        Binding(
            get: { state.isReachabilityRequired },
            set: { state.isReachabilityRequired = $0 }
        )
    }

    private var previewPresentationBinding: Binding<Bool> {
        Binding(
            get: { state.isPresentingPreview },
            set: { isPresented in
                if isPresented {
                    state.isPresentingPreview = true
                } else {
                    state.dismissPreview()
                }
            }
        )
    }

    private var shareSheetPresentationBinding: Binding<Bool> {
        Binding(
            get: { state.isPresentingShareSheet },
            set: { isPresented in
                if isPresented {
                    state.isPresentingShareSheet = true
                } else {
                    state.dismissShareSheet()
                }
            }
        )
    }

    private var wkWebViewPresentationBinding: Binding<Bool> {
        Binding(
            get: { state.isPresentingWKWebView },
            set: { isPresented in
                if isPresented {
                    state.isPresentingWKWebView = true
                } else {
                    state.dismissWKWebView()
                }
            }
        )
    }
}

private struct PDFPoCStatusView: View {
    let title: String
    let result: PDFPoCResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            HStack(alignment: .top, spacing: 12) {
                Image(systemName: result.kind.systemImage)
                    .foregroundStyle(result.kind.tintColor)
                    .frame(width: 20)

                VStack(alignment: .leading, spacing: 4) {
                    Text(result.kind.rawValue.capitalized)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(result.kind.tintColor)

                    Text(result.message)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
            }

            if result.kind == .running {
                ProgressView()
                    .controlSize(.small)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private extension PDFPoCResultKind {
    var systemImage: String {
        switch self {
        case .idle:
            return "circle.dashed"
        case .running:
            return "arrow.triangle.2.circlepath"
        case .success:
            return "checkmark.circle.fill"
        case .failure:
            return "xmark.circle.fill"
        }
    }

    var tintColor: Color {
        switch self {
        case .idle:
            return .secondary
        case .running:
            return .blue
        case .success:
            return .green
        case .failure:
            return .red
        }
    }
}

#Preview {
    NavigationStack {
        PDFPoCView()
    }
}
