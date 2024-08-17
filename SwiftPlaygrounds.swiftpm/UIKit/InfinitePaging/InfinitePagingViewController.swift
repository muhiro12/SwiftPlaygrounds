import SwiftUI

final class InfinitePagingViewController: UIViewController {
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )

    private lazy var viewControllers = (0..<5).map {
        buildViewController($0)
    }

    private var index = 0    

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self

        pageViewController.setViewControllers(
            [viewControllers[0]],
            direction: .forward,
            animated: true
        )
        pageViewController.view.clipsToBounds = false
        for view in pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.clipsToBounds = false
            }
        }
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
        ])
    }
    
    func buildViewController(_ number: Int) -> UIViewController {
        let vc = UIViewController()
        let label = UILabel()
        label.text = number.description
        label.textAlignment = .center
        label.backgroundColor = .init(red: .random(in: 0...1),
                                      green: .random(in: 0...1),
                                      blue: .random(in: 0...1),
                                      alpha: 1)
        
        vc.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 200),
            label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
        ])
        
        return vc
    }
}

extension InfinitePagingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        index -= 1
        if index < viewControllers.startIndex {
            index = viewControllers.endIndex - 1
        }
        return viewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        index += 1
        if index > viewControllers.endIndex - 1 {
            index = viewControllers.startIndex
        }
        return viewControllers[index]
    }
}

struct InfinitePagingView: View {
    var body: some View {
        ViewControllerRepresentable {
            InfinitePagingViewController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InfinitePagingView()
}
