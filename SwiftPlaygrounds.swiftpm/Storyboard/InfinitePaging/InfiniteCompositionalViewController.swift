import SwiftUI

final class InfiniteCompositionalViewController: UIViewController {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
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
            cell.backgroundColor = .init(red: .random(in: 0...1),
                                         green: .random(in: 0...1),
                                         blue: .random(in: 0...1),
                                         alpha: 1)
            cell.layer.cornerRadius = 4

            let label = (cell.subviews.first as? UILabel) ?? .init()
            label.text = indexPath.item.description
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
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)
                )
            )
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .absolute(300),
                    heightDimension: .absolute(200)
                ),
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
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
