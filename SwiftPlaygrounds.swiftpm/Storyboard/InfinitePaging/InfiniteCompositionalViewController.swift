import SwiftUI

final class InfiniteCompositionalViewController: UIViewController {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    private let colors = [(0..<3).map { _ in
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1)
    }].flatMap { $0 + $0 + $0 }
    private let texts = [(0..<3).map { $0.description }].flatMap { $0 + $0 + $0 }
    
    
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
        snapshot.appendItems(colors.indices.map { $0 }, toSection: 0)
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
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .fractionalWidth(0.6)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            section.visibleItemsInvalidationHandler = { _, point, environment in
                let width = self.view.bounds.width * 0.8
                let point = round(point.x + self.view.bounds.width * 0.1)
                let centerItem = self.colors.endIndex / 3
                if point == 0 {
                    self.collectionView.scrollToItem(
                        at: .init(item: centerItem, section: 0),
                        at: [],
                        animated: false
                    )
                } else if point == round(width * CGFloat(self.colors.endIndex - 1)) {
                    self.collectionView.scrollToItem(
                        at: .init(item: centerItem - 1, section: 0),
                        at: [],
                        animated: false
                    )
                }
            }
            
            return section
        }
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        collectionView.scrollToItem(
            at: .init(item: self.colors.endIndex / 3, section: 0),
            at: [],
            animated: false
        )
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
