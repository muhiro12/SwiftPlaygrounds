import SwiftUI
import WebKit

final class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .systemBackground
        let label = UILabel()
        label.text = "Home"
        label.textAlignment = .center
        label.frame = view.bounds
        view.addSubview(label)
    }
}

final class OtherRootViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Other"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "Next", style: .plain, target: self, action: #selector(goSettings))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("debug: OtherRootVC viewWillAppear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("debug: OtherRootVC viewDidAppear")
    }
    @objc private func goSettings() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}

final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = .init(title: "Web", style: .plain, target: self, action: #selector(goWeb))
    }
    @objc private func goWeb() {
        navigationController?.pushViewController(BugWebViewController(), animated: true)
    }
}

final class BugWebViewController: UIViewController, WKNavigationDelegate {
    private let webView = WKWebView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BugWeb"
        webView.navigationDelegate = self
        webView.loadHTMLString("""
        <html>
          <body>
            <a href='myapp://home_old'>Go Home (Old)</a><br>
            <a href='myapp://home_new1'>Go Home (New1)</a><br>
            <a href='myapp://home_new2'>Go Home (New2)</a>
          </body>
        </html>
        """, baseURL: nil)
        view.addSubview(webView)
        webView.frame = view.bounds
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.request.url?.absoluteString.hasPrefix("myapp://home_old") == true {
            navigateHomeByOldImplements()
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.absoluteString.hasPrefix("myapp://home_new1") == true {
            navigateHomeByNewImplements()
            decisionHandler(.cancel)
        } else if navigationAction.request.url?.absoluteString.hasPrefix("myapp://home_new2") == true {
            navigateHomeByNewImplements2()
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    private func navigateHomeByOldImplements() {
        navigationController?.popToRootViewController(animated: false)
        tabBarController?.selectedIndex = 0
    }
    private func navigateHomeByNewImplements() {
        tabBarController?.selectedIndex = 0
        navigationController?.popToRootViewController(animated: false)
    }
    private func navigateHomeByNewImplements2() {
        tabBarController?.selectedIndex = 0
        if let tc = tabBarController?.transitionCoordinator {
            tc.animate(alongsideTransition: nil) { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: false)
            }
        } else {
            navigationController?.popToRootViewController(animated: false)
        }
    }
}

final class NavigationBugTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: nil)
        let othersNav = UINavigationController(rootViewController: OtherRootViewController())
        othersNav.tabBarItem = UITabBarItem(title: "Other", image: UIImage(systemName: "ellipsis.circle"), selectedImage: nil)
        viewControllers = [homeNav, othersNav]
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
