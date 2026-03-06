import SwiftUI
import SafariServices
import WebKit
import UIKit
import AuthenticationServices

struct WebIntegrationView: View {
    @EnvironmentObject private var deepLinkNavigator: DeepLinkNavigator

    @State private var serverURLString = "http://127.0.0.1:8080"
    @State private var authURLString = "http://127.0.0.1:8080/auth"
    @State private var callbackScheme = DeepLink.scheme
    @State private var prefersEphemeral = false
    @State private var forwardCallbackToDeepLink = false
    @State private var statusMessage = "Ready."
    @State private var presentedSheet: WebIntegrationSheet?
    @State private var webAuthenticationSession: ASWebAuthenticationSession?
    @State private var presentationContextProvider = WebIntegrationPresentationContextProvider()

    var body: some View {
        Form {
            Section("Overview") {
                Text("Compare deep-link handling in WKWebView, Safari, and ASWebAuthenticationSession from one place.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Text("Start `VaporServer` with `swift run` before loading the local server pages.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("URLs") {
                TextField("Server URL", text: $serverURLString)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.URL)

                TextField("Auth URL", text: $authURLString)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)
                    .keyboardType(.URL)
            }

            Section("WKWebView") {
                Button("Open Server Page in WKWebView") {
                    guard validateServerURL() else {
                        return
                    }
                    presentedSheet = .serverWebView
                }

                Button("Open Deep Link Examples") {
                    presentedSheet = .deepLinkExamples
                }
            }

            Section("Safari") {
                Button("Open Server Page in Safari") {
                    guard validateServerURL() else {
                        return
                    }
                    presentedSheet = .safari
                }
            }

            Section("Web Authentication Session") {
                TextField("Callback Scheme", text: $callbackScheme, prompt: Text(DeepLink.scheme))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled(true)

                Toggle("Ephemeral Session", isOn: $prefersEphemeral)
                Toggle("Forward Callback to Deep Link", isOn: $forwardCallbackToDeepLink)

                Button("Start Standard Session") {
                    prefersEphemeral = false
                    if callbackScheme.isEmpty {
                        callbackScheme = DeepLink.scheme
                    }
                    startWebAuthenticationSession()
                }

                Button("Start Ephemeral Session") {
                    prefersEphemeral = true
                    if callbackScheme.isEmpty {
                        callbackScheme = DeepLink.scheme
                    }
                    startWebAuthenticationSession()
                }

                Button("Start Without Callback") {
                    callbackScheme = ""
                    prefersEphemeral = false
                    startWebAuthenticationSession()
                }

                Button("Start Session With Current Settings") {
                    startWebAuthenticationSession()
                }
                .buttonStyle(.borderedProminent)
            }

            Section("Last Result") {
                Text(statusMessage)
                    .font(.caption.monospaced())
                    .textSelection(.enabled)
            }
        }
        .navigationTitle("Web Integration")
        .sheet(item: $presentedSheet) { sheet in
            switch sheet {
            case .serverWebView:
                if let serverURL {
                    NavigationStack {
                        WebIntegrationWKWebView(page: .url(serverURL))
                            .navigationTitle("WKWebView")
                            .toolbar {
                                ToolbarItem(placement: .topBarLeading) {
                                    Button("Close") {
                                        presentedSheet = nil
                                    }
                                }
                            }
                    }
                }
            case .deepLinkExamples:
                NavigationStack {
                    WebIntegrationWKWebView(page: .html(WebIntegrationWKWebView.deepLinkHTML))
                        .navigationTitle("Deep Links")
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button("Close") {
                                    presentedSheet = nil
                                }
                            }
                        }
                }
            case .safari:
                if let serverURL {
                    WebIntegrationSafariView(url: serverURL)
                }
            }
        }
    }

    private var serverURL: URL? {
        URL(string: serverURLString)
    }

    private var authURL: URL? {
        URL(string: authURLString)
    }

    private func validateServerURL() -> Bool {
        guard serverURL != nil else {
            statusMessage = "Invalid server URL."
            return false
        }
        return true
    }

    private func startWebAuthenticationSession() {
        guard let authURL else {
            statusMessage = "Invalid auth URL."
            return
        }

        let scheme = callbackScheme.isEmpty ? nil : callbackScheme
        let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { callbackURL, error in
            if let callbackURL {
                statusMessage = "Callback: \(callbackURL.absoluteString)"
                if forwardCallbackToDeepLink {
                    _ = deepLinkNavigator.handle(url: callbackURL)
                }
                return
            }

            if let error {
                statusMessage = "Error: \(error.localizedDescription)"
                return
            }

            statusMessage = "Cancelled."
        }
        session.prefersEphemeralWebBrowserSession = prefersEphemeral
        session.presentationContextProvider = presentationContextProvider
        if session.start() {
            webAuthenticationSession = session
            statusMessage = "Started web authentication session."
        } else {
            statusMessage = "Failed to start web authentication session."
        }
    }
}

private enum WebIntegrationSheet: String, Identifiable {
    case serverWebView
    case deepLinkExamples
    case safari

    var id: String {
        rawValue
    }
}

private enum WebIntegrationPage: Equatable {
    case url(URL)
    case html(String)
}

private struct WebIntegrationSafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        .init(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

private struct WebIntegrationWKWebView: UIViewControllerRepresentable {
    let page: WebIntegrationPage

    static let deepLinkHTML = """
    <html>
      <body>
        <h3>Deep link examples</h3>
        <ul>
          <li><a href="\(DeepLink.scheme)://route/keychain-lab">Host route + hyphen path</a></li>
          <li><a href="\(DeepLink.scheme)://stateComparison">Host omitted + camelCase</a></li>
          <li><a href="\(DeepLink.scheme)://route/flash-test">Host route + kebab path</a></li>
          <li><a href="\(DeepLink.scheme)://photoRef">Another surviving route</a></li>
          <li><a href="\(DeepLink.scheme)://alert">Show alert instead of deep link</a></li>
          <li><a href="maps://?q=Tokyo+Station">maps://?q=Tokyo+Station</a></li>
        </ul>
      </body>
    </html>
    """

    func makeUIViewController(context: Context) -> UIViewController {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        let viewController = UIViewController()
        viewController.view = webView
        context.coordinator.presentingViewController = viewController
        context.coordinator.loadedPage = page
        load(page: page, into: webView)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let webView = uiViewController.view as? WKWebView else {
            return
        }
        guard context.coordinator.loadedPage != page else {
            return
        }
        context.coordinator.loadedPage = page
        load(page: page, into: webView)
    }

    func makeCoordinator() -> Coordinator {
        .init()
    }

    private func load(page: WebIntegrationPage, into webView: WKWebView) {
        switch page {
        case .url(let url):
            webView.load(URLRequest(url: url))
        case .html(let html):
            webView.loadHTMLString(html, baseURL: nil)
        }
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        weak var presentingViewController: UIViewController?
        var loadedPage: WebIntegrationPage?

        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = navigationAction.request.url else {
                decisionHandler(.allow)
                return
            }

            guard url.scheme == DeepLink.scheme else {
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
                title: "Deep Link Blocked",
                message: "\(url.absoluteString) was intercepted by the in-page alert rule.",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            presentingViewController?.present(alert, animated: true)
        }
    }
}

#if os(iOS)
private final class WebIntegrationPresentationContextProvider: NSObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.keyWindow ?? ASPresentationAnchor()
    }
}
#endif

#Preview {
    NavigationStack {
        WebIntegrationView()
            .environmentObject(DeepLinkNavigator())
    }
}
