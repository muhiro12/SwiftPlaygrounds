import SwiftUI
import WebKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

final class OtherRootViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("OtherRootVC viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("OtherRootVC viewDidAppear")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "Next", style: .plain, target: self, action: #selector(goSettings))
    }
    @objc private func goSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "Web", style: .plain, target: self, action: #selector(goWeb))
    }
    @objc private func goWeb() {
        navigationController?.pushViewController(BugWebViewController(useNewImplementation: false), animated: true)
    }
}

final class BugWebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()
    private let useNewImplementation: Bool
    init(useNewImplementation: Bool) {
        self.useNewImplementation = useNewImplementation
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        webView.loadHTMLString("<a href='myapp://home'>Go Home</a>", baseURL: nil)
        view.addSubview(webView)
        webView.frame = view.bounds
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.scheme == "myapp" {
            navigateHome()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    private func navigateHome() {
        guard let tab = tabBarController, let nav = tab.viewControllers?[4] as? UINavigationController else { return }
        if useNewImplementation {
            tab.selectedIndex = 0
            if let tc = tab.transitionCoordinator {
                tc.animate(alongsideTransition: nil) { _ in
                    nav.popToRootViewController(animated: false)
                }
            } else {
                nav.popToRootViewController(animated: false)
            }
        } else {
            nav.popToRootViewController(animated: false)
            tab.selectedIndex = 0
        }
    }
}

final class NavigationBugTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        homeNav.tabBarItem.title = "Home"
        let othersNav = UINavigationController(rootViewController: OtherRootViewController())
        othersNav.tabBarItem.title = "Other"
        viewControllers = [homeNav, UIViewController(), UIViewController(), UIViewController(), othersNav]
    }
}

struct NavigationBugView: View {
    var body: some View {
        ViewControllerRepresentable {
            NavigationBugTabBarController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    NavigationBugView()
}
