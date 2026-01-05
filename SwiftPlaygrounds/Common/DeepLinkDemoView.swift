import SwiftUI
import SafariServices
import WebKit
import UIKit
import AuthenticationServices

struct DeepLinkDemoView: View {
    private let serverURL = URL(string: "http://127.0.0.1:8080")!

    @State private var showSafari = false
    @State private var showWebView = false
    @State private var webAuthSession: ASWebAuthenticationSession?
    @State private var presentationContextProvider = PresentationContextProvider()

    var body: some View {
        VStack(spacing: 16) {
            Text("同一ページを3種類のWeb表示で開き、playgrounds:// と maps:// の挙動差を確認します。先に `VaporServer` で `swift run` しておいてください。")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.leading)

            Button("WKWebViewで開く", systemImage: "chevron.left.forwardslash.chevron.right") {
                showWebView = true
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showWebView) {
                NavigationStack {
                    DeepLinkWKWebView(url: serverURL)
                        .navigationTitle("WKWebView")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    showWebView = false
                                }
                            }
                        }
                }
            }

            Button("SFSafariViewControllerで開く", systemImage: "safari") {
                showSafari = true
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $showSafari) {
                SafariView(url: serverURL)
            }

            Button("ASWebAuthenticationSessionで開く", systemImage: "lock.shield") {
                startWebAuthSession()
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: .infinity)

            Spacer()
        }
        .padding()
        .navigationTitle("Deep Link Demo")
    }
}

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

private struct DeepLinkWKWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> UIViewController {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        let vc = UIViewController()
        vc.view = webView
        context.coordinator.presentingViewController = vc
        webView.load(URLRequest(url: url))
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        weak var presentingViewController: UIViewController?

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            guard let url = navigationAction.request.url,
                  url.scheme == DeepLink.scheme else {
                decisionHandler(.allow)
                return
            }

            if DeepLink.shouldPresentAlert(for: url) {
                presentAlert(for: url)
                decisionHandler(.cancel)
                return
            }

            UIApplication.shared.open(url)
            decisionHandler(.cancel)
        }

        private func presentAlert(for url: URL) {
            let alert = UIAlertController(
                title: "ディープリンクを抑制しました",
                message: "\(url.absoluteString) はページ内アラートの対象です。",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            presentingViewController?.present(alert, animated: true)
        }
    }
}

#if os(iOS)
private final class PresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow ?? ASPresentationAnchor()
    }
}
#endif

private extension DeepLinkDemoView {
    func startWebAuthSession() {
        let session = ASWebAuthenticationSession(
            url: serverURL,
            callbackURLScheme: nil
        ) { _, _ in
            // Deep linkでアプリに戻る想定なので特に処理なし
        }
        session.prefersEphemeralWebBrowserSession = true
        session.presentationContextProvider = presentationContextProvider
        session.start()
        webAuthSession = session
    }
}

#Preview {
    NavigationStack {
        DeepLinkDemoView()
    }
}
