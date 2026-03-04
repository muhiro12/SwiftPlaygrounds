import PDFKit
import SwiftUI
import UIKit
import WebKit

struct PDFKitView: UIViewRepresentable {
    let document: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.displayMode = .singlePageContinuous
        pdfView.document = document
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = document
    }
}

struct ActivityViewControllerRepresentable: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct PDFPoCWKWebView: UIViewRepresentable {
    let url: URL
    let onEvent: (String, Error?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onEvent: onEvent)
    }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.loadedURL = url
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard context.coordinator.loadedURL != url else {
            return
        }

        context.coordinator.loadedURL = url
        uiView.load(URLRequest(url: url))
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var loadedURL: URL?

        private let onEvent: (String, Error?) -> Void

        init(onEvent: @escaping (String, Error?) -> Void) {
            self.onEvent = onEvent
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            loadedURL = webView.url ?? loadedURL
            onEvent("didStartProvisionalNavigation", nil)
        }

        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            loadedURL = webView.url ?? loadedURL
            onEvent("didCommit", nil)
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            loadedURL = webView.url ?? loadedURL
            onEvent("didFinish", nil)
        }

        func webView(
            _ webView: WKWebView,
            didFail navigation: WKNavigation!,
            withError error: Error
        ) {
            onEvent("didFailNavigation", error)
        }

        func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            onEvent("didFailProvisionalNavigation", error)
        }
    }
}
