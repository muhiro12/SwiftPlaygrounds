import SwiftUI
import WebKit

struct ToolbarWebView: View {
    private let webView = WKWebView()
    private let documentController = UIDocumentInteractionController()

    var body: some View {
        VStack {
            ViewControllerRepresentable {
                ToolbarWebViewController(webView: webView)
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
                Button("Print", systemImage: "printer") {
                    let controller = UIPrintInteractionController()
                    controller.printFormatter = webView.viewPrintFormatter()
                    controller.present(animated: true)
                }
                .frame(maxWidth: .infinity)
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
            .labelStyle(.iconOnly)
        }
    }
}

final class ToolbarWebViewController: UIViewController {
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
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: webView.leadingAnchor),
            view.topAnchor.constraint(equalTo: webView.topAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: webView.bottomAnchor)
        ])

        webView.load(
            .init(
                url: .init(string: "https://google.com")!
            )
        )
    }
}

#Preview {
    ToolbarWebView()
}