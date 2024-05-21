import SwiftUI

final class InfinitePagingViewController: UIViewController {
    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal
    )
    private let numbers = 0..<5

    private var index = 0    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers(
            [buildViewController(numbers.startIndex)], 
            direction: .forward,
            animated: true
        )        
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func buildViewController(_ number: Int) -> UIViewController {
        let vc = UIViewController()
        let label = UILabel()
        label.text = number.description
        vc.view.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            vc.view.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            vc.view.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        return vc
    }
}

extension InfinitePagingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        index -= 1
        if index < numbers.startIndex {
            index = numbers.endIndex - 1
        }
        return buildViewController(numbers[index])
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        index += 1
        if index > numbers.endIndex - 1 {
            index = numbers.startIndex
        }
        return buildViewController(numbers[index])
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
