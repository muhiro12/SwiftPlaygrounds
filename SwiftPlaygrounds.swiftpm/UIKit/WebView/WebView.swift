import SwiftUI
import WebKit

struct WebView: View {
    var body: some View {
        ViewControllerRepresentable {
            WebViewController()
        }
        .ignoresSafeArea()
    }
}

final class WebViewController: UIViewController {
    private let webView = WKWebView()
    
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
    WebView()
}
