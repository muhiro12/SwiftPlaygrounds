import SwiftUI

final class InfiniteCompositionalViewController: UIViewController {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    private let count = 3
    private lazy var colors = [(0..<count).map { _ in
        UIColor(red: .random(in: 0...1),
                green: .random(in: 0...1),
                blue: .random(in: 0...1),
                alpha: 1)
    }].flatMap { $0 + $0 + $0 }
    private lazy var texts = [(0..<count).map { $0.description }].flatMap { $0 + $0 + $0 }

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

        dataSource = .init(collectionView: collectionView) { [weak self] collectionView, indexPath, _ in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = self?.colors[indexPath.item]
            cell.layer.cornerRadius = 4

            let label = (cell.subviews.first as? UILabel) ?? .init()
            label.text = self?.texts[indexPath.item]
            label.translatesAutoresizingMaskIntoConstraints = false

            cell.addSubview(label)

            NSLayoutConstraint.activate([
                cell.centerXAnchor.constraint(equalTo: label.centerXAnchor),
                cell.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])

            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(colors.indices.map { $0 }, toSection: .zero)
        dataSource?.apply(snapshot)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { _, _ in
            let widthFactor = 0.8
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
                    widthDimension: .fractionalWidth(widthFactor),
                    heightDimension: .fractionalWidth(widthFactor * widthFactor)
                ),
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered

            section.visibleItemsInvalidationHandler = { [weak self] _, point, _ in
                guard let self else {
                    return
                }
                let itemWidth = view.bounds.width * widthFactor
                let leadingPoint = round(point.x + (view.bounds.width - itemWidth) / 2)
                if leadingPoint == .zero {
                    collectionView.scrollToItem(
                        at: .init(item: colors.endIndex / count * (count - 1), section: .zero),
                        at: [],
                        animated: false
                    )
                } else if leadingPoint == round(itemWidth * CGFloat(colors.endIndex - 1)) {
                    collectionView.scrollToItem(
                        at: .init(item: colors.endIndex / count - 1, section: 0),
                        at: [],
                        animated: false
                    )
                }
            }

            return section
        }

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.scrollToItem(
            at: .init(item: colors.endIndex / count, section: .zero),
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
