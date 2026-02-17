import SwiftUI
import WebKit

struct FlashTestView: View {
    @State private var configuration = FlashTestConfiguration.default

    var body: some View {
        VStack(spacing: 0) {
            FlashTestWebView(configuration: $configuration)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Section(header: Text("Navigation Trigger")) {
                        Picker("Trigger", selection: $configuration.navigationTrigger) {
                            ForEach(FlashTestNavigationTrigger.allCases) { trigger in
                                Text(trigger.title).tag(trigger)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section(header: Text("Cache Mode")) {
                        Picker("Cache", selection: $configuration.cacheMode) {
                            ForEach(FlashTestCacheMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section(header: Text("Old Image Delay")) {
                        Toggle("Enable", isOn: $configuration.isOldDelayEnabled)
                        Stepper(value: $configuration.oldDelayMs, in: 0...300, step: 50) {
                            Text("oldDelayMs: \(configuration.oldDelayMs)")
                        }
                        .disabled(!configuration.isOldDelayEnabled)
                    }

                    Section(header: Text("DOM Insert Delay")) {
                        Toggle("Enable", isOn: $configuration.isDomDelayEnabled)
                        Stepper(value: $configuration.domDelayMs, in: 0...300, step: 50) {
                            Text("domDelayMs: \(configuration.domDelayMs)")
                        }
                        .disabled(!configuration.isDomDelayEnabled)
                    }

                    Section(header: Text("Hide Mode")) {
                        Picker("Hide", selection: $configuration.hideMode) {
                            ForEach(FlashTestHideMode.allCases) { mode in
                                Text(mode.title).tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section(header: Text("Host")) {
                        TextField("http://127.0.0.1:8080", text: $configuration.baseURLString)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .keyboardType(.URL)
                    }
                }
                .padding()
            }
            .frame(maxHeight: 320)
        }
        .navigationTitle("Flash Test")
    }
}

private struct FlashTestWebView: UIViewControllerRepresentable {
    @Binding var configuration: FlashTestConfiguration

    func makeUIViewController(context: Context) -> FlashTestViewController {
        FlashTestViewController(configuration: configuration)
    }

    func updateUIViewController(_ uiViewController: FlashTestViewController, context: Context) {
        uiViewController.updateConfiguration(configuration)
    }
}

final class FlashTestViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {
    private var configuration: FlashTestConfiguration
    private let startTime = CACurrentMediaTime()
    private let webView: WKWebView

    init(configuration: FlashTestConfiguration) {
        self.configuration = configuration
        let userContentController = WKUserContentController()
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.userContentController = userContentController
        self.webView = WKWebView(frame: .zero, configuration: webConfiguration)

        super.init(nibName: nil, bundle: nil)

        let consoleBridge = WKUserScript(
            source: Self.consoleBridgeScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: true
        )
        webView.configuration.userContentController.addUserScript(consoleBridge)
        webView.configuration.userContentController.add(self, name: "log")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "log")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])

        loadPage()
    }

    func updateConfiguration(_ newConfiguration: FlashTestConfiguration) {
        guard configuration != newConfiguration else { return }
        configuration = newConfiguration
        loadPage()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        log("didCommit")
        switch configuration.navigationTrigger {
        case .didCommit:
            injectSwapScript(reason: "didCommit")
        case .domContentLoaded:
            injectSwapScript(reason: "domContentLoaded")
        case .didFinish:
            break
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        log("didFinish")
        if configuration.navigationTrigger == .didFinish {
            injectSwapScript(reason: "didFinish")
        }
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        log("web \(message.body)")
    }

    private func loadPage() {
        guard let url = makeURL() else {
            log("Invalid URL: \(configuration.baseURLString)")
            return
        }

        log("Load \(url.absoluteString)")
        webView.load(URLRequest(url: url))
    }

    private func makeURL() -> URL? {
        guard var components = URLComponents(string: configuration.baseURLString) else { return nil }
        components.path = "/flash-test"

        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "cache", value: configuration.cacheMode.rawValue)
        ]

        if configuration.isOldDelayEnabled {
            queryItems.append(URLQueryItem(name: "oldDelayMs", value: "\(configuration.oldDelayMs)"))
        }

        if configuration.isDomDelayEnabled {
            queryItems.append(URLQueryItem(name: "domDelayMs", value: "\(configuration.domDelayMs)"))
        }

        components.queryItems = queryItems
        return components.url
    }

    private func injectSwapScript(reason: String) {
        let js = swapScript(reason: reason)
        log("evaluateJavaScript \(reason)")
        webView.evaluateJavaScript(js) { [weak self] _, error in
            if let error {
                self?.log("evaluateJavaScript completion error: \(error.localizedDescription)")
            } else {
                self?.log("evaluateJavaScript completion success")
            }
        }
    }

    private func swapScript(reason: String) -> String {
        let newImageURL = "/assets/new.jpg?cache=\(configuration.cacheMode.rawValue)"
        let hideMode = configuration.hideMode
        let hideStyle: String
        let showStyle: String
        switch hideMode {
        case .visibilityHidden:
            hideStyle = "target.style.visibility = 'hidden';"
            showStyle = "target.style.visibility = 'visible';"
        case .displayNone:
            hideStyle = "target.style.display = 'none';"
            showStyle = "target.style.display = '';"
        }

        return """
        (function() {
            const log = (msg, extra) => {
                const t = performance.now().toFixed(1);
                if (extra !== undefined) {
                    console.log(`[ios-swap +${t}ms] ${msg}`, extra);
                } else {
                    console.log(`[ios-swap +${t}ms] ${msg}`);
                }
            };
            const reason = "\(reason)";
            const newSrc = "\(newImageURL)";

            const runSwap = (target) => {
                if (!target) {
                    log('target not found');
                    return;
                }
                log('swap start', { reason: reason, oldSrc: target.src, newSrc: newSrc });
                \(hideStyle)
                target.onload = () => {
                    log('target load', { src: target.currentSrc || target.src });
                    \(showStyle)
                };
                target.onerror = () => {
                    log('target error', { src: target.currentSrc || target.src });
                    \(showStyle)
                };
                target.src = newSrc;
                log('src replaced', { src: target.getAttribute('src') });
            };

            const waitForTarget = () => {
                let tries = 0;
                const attempt = () => {
                    const target = document.querySelector('#target');
                    if (target) {
                        runSwap(target);
                        return;
                    }
                    tries += 1;
                    if (tries < 120) {
                        requestAnimationFrame(attempt);
                    } else {
                        log('target not found after retries');
                    }
                };
                attempt();
            };

            if (reason === 'domContentLoaded') {
                if (document.readyState === 'loading') {
                    log('waiting DOMContentLoaded');
                    document.addEventListener('DOMContentLoaded', waitForTarget, { once: true });
                } else {
                    waitForTarget();
                }
            } else {
                waitForTarget();
            }
        })();
        """
    }

    private func log(_ message: String) {
        let deltaMs = (CACurrentMediaTime() - startTime) * 1000
        print(String(format: "[FlashTest +%.1fms] %@", deltaMs, message))
    }

    private static var consoleBridgeScript: String {
        """
        (function() {
            const original = console.log;
            console.log = function(...args) {
                try {
                    window.webkit.messageHandlers.log.postMessage(args.map(String).join(' '));
                } catch (e) {}
                original.apply(console, args);
            };
        })();
        """
    }
}

struct FlashTestConfiguration: Equatable {
    var baseURLString: String
    var navigationTrigger: FlashTestNavigationTrigger
    var cacheMode: FlashTestCacheMode
    var isOldDelayEnabled: Bool
    var oldDelayMs: Int
    var isDomDelayEnabled: Bool
    var domDelayMs: Int
    var hideMode: FlashTestHideMode

    static let `default` = FlashTestConfiguration(
        baseURLString: "http://127.0.0.1:8080",
        navigationTrigger: .didFinish,
        cacheMode: .maxAge,
        isOldDelayEnabled: false,
        oldDelayMs: 150,
        isDomDelayEnabled: false,
        domDelayMs: 150,
        hideMode: .visibilityHidden
    )
}

enum FlashTestNavigationTrigger: String, CaseIterable, Identifiable {
    case didCommit
    case didFinish
    case domContentLoaded

    var id: String { rawValue }

    var title: String {
        switch self {
        case .didCommit:
            return "didCommit"
        case .didFinish:
            return "didFinish"
        case .domContentLoaded:
            return "DOMContentLoaded"
        }
    }
}

enum FlashTestCacheMode: String, CaseIterable, Identifiable {
    case maxAge = "maxage"
    case noStore = "nostore"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .maxAge:
            return "max-age"
        case .noStore:
            return "no-store"
        }
    }
}

enum FlashTestHideMode: String, CaseIterable, Identifiable {
    case visibilityHidden
    case displayNone

    var id: String { rawValue }

    var title: String {
        switch self {
        case .visibilityHidden:
            return "visibility"
        case .displayNone:
            return "display"
        }
    }
}

#Preview {
    FlashTestView()
}
