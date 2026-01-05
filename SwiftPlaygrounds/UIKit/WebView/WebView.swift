import SwiftUI
import WebKit

struct WebView: View {
    private let webView = WKWebView()
    private let documentController = UIDocumentInteractionController()

    var body: some View {
        VStack {
            ViewControllerRepresentable {
                WebViewController(webView: webView)
            }
            VStack {
                HStack {
                    Button("Print", systemImage: "printer") {
                        let controller = UIPrintInteractionController()
                        controller.printFormatter = webView.viewPrintFormatter()
                        controller.present(animated: true)
                    }
                    .frame(maxWidth: .infinity)
                    if false {
                        Button("PDF", systemImage: "document.badge.ellipsis") {
                            Task {
                                do {
                                    let title = webView.title ?? "temp"
                                    let filePath = URL(filePath: NSTemporaryDirectory() + title + ".pdf")
                                    let pdf = try await webView.pdf()
                                    try pdf.write(to: filePath)
                                    documentController.url = filePath
                                    documentController.presentOptionsMenu(from: webView.frame, in: webView, animated: true)
                                } catch {}
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    if false {
                        Button("Scraping", systemImage: "applescript") {
                            Task {
                                let js = """
                                     const response = await fetch('https://www.google.com', {
                                        method: 'GET'
                                     })
                                     location.href = response.url
                                     """
                                do {
                                    let result = try await webView.callAsyncJavaScript(js, contentWorld: .defaultClient)
                                    print(result ?? "nil")
                                } catch {
                                    print(error)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                HStack {
                    Button("Deep Link Test", systemImage: "link") {
                        webView.loadHTMLString(WebViewController.deepLinkHTML, baseURL: nil)
                    }
                    .frame(maxWidth: .infinity)
                }
                HStack {
                    Button("Back", systemImage: "arrowtriangle.backward") {
                        webView.goBack()
                    }
                    .frame(maxWidth: .infinity)
                    Button("Go", systemImage: "arrowtriangle.forward") {
                        webView.goForward()
                    }
                    .frame(maxWidth: .infinity)
                    Button("Reload", systemImage: "arrow.trianglehead.clockwise") {
                        webView.reload()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .labelStyle(.iconOnly)
        }
    }
}

final class WebViewController: UIViewController, WKNavigationDelegate {
    private let webView: WKWebView

    init(webView: WKWebView) {
        self.webView = webView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])

        loadDeepLinkDemo()
    }

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

    private func loadDeepLinkDemo() {
        webView.loadHTMLString(Self.deepLinkHTML, baseURL: nil)
    }

    static var deepLinkHTML: String {
        """
        <html><body>
        <h3>Deep link examples</h3>
        <ul>
          <li><a href="\(DeepLink.scheme)://route/keychain-biometry-debug">Host route + hyphen path</a></li>
          <li><a href="\(DeepLink.scheme)://keychainBiometryDebug">Host omitted + camelCase</a></li>
          <li><a href="\(DeepLink.scheme)://route/hybrid-text-field">Host route + kebab</a></li>
          <li><a href="\(DeepLink.scheme)://webView">Host omitted + other screen</a></li>
          <li><a href="\(DeepLink.scheme)://alert">Show alert instead of deep link</a></li>
        </ul>
        </body></html>
        """
    }

    private func presentAlert(for url: URL) {
        let alert = UIAlertController(
            title: "ディープリンクを抑制しました",
            message: "\(url.absoluteString) はページ内アラートの対象です。",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

#Preview {
    WebView()
}
