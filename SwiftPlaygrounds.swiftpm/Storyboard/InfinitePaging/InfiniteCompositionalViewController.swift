import SwiftUI

final class InfiniteCompositionalViewController: UIViewController {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let colors = [(0..<5).map { _ in
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1)
    }].flatMap { $0 + $0 }
    private let texts = [(0..<5).map { $0.description }].flatMap { $0 + $0 }

    
    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = self.colors[indexPath.item]
            cell.layer.cornerRadius = 4
            
            let label = (cell.subviews.first as? UILabel) ?? .init()
            label.text = self.texts[indexPath.item]
            label.translatesAutoresizingMaskIntoConstraints = false
            
            cell.addSubview(label)        
            
            NSLayoutConstraint.activate([
                cell.centerXAnchor.constraint(equalTo: label.centerXAnchor),
                cell.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            ])
            
            return cell
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([0])
        snapshot.appendItems((0..<10).map { $0 }, toSection: 0)
        dataSource?.apply(snapshot)
        
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { index, _ in
            let margin = 8.0
            
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = .init(top: margin, leading: margin, bottom: margin, trailing: margin)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = { _, point, environment in
                let point = point.x + 41.5
                let firstPoint: CGFloat = 300 * 0
                let endPoint: CGFloat = 300 * 9
                if point == firstPoint {
                    self.collectionView.scrollToItem(at: IndexPath(item: 5, section: 0), at: [], animated: false)
                } else if point == endPoint {
                    self.collectionView.scrollToItem(at: IndexPath(item: 4, section: 0), at: [], animated: false)
                }
            }
            
            return section
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

struct InfiniteCompositionalView: View {
    var body: some View {
        ViewControllerRepresentable {
            InfiniteCompositionalViewController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    InfiniteCompositionalView()
}
