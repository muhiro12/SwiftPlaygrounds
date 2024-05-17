//
//  CompositionalViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/27.
//

import SwiftUI

final class CompositionalViewController: UIViewController {
    private let collectionView = UICollectionView()

    private var dataSource: UICollectionViewDiffableDataSource<Int, Int>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.frame = view.frame

        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = .init(red: .random(in: 0...1),
                                         green: .random(in: 0...1),
                                         blue: .random(in: 0...1),
                                         alpha: 1)
            cell.layer.cornerRadius = 4
            let label = cell.subviews.first?.subviews.first as? UILabel
            label?.text = "\(indexPath.section), \(indexPath.item)"
            return cell
        }

        var snapshot = NSDiffableDataSourceSnapshot<Int, Int>()
        let sections = [0, 1, 2, 3]
        snapshot.appendSections(sections)
        sections.forEach { section in
            snapshot.appendItems([0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map { section * 10 + $0 },
                                 toSection: section)
        }
        dataSource?.apply(snapshot)

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { index, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1 / CGFloat(4 - index))
                )
            )
            item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1 / CGFloat(index + 1)),
                    heightDimension: .fractionalHeight(1 / CGFloat(index + 1))
                ),
                subitems: [item]
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered

            return section
        }
    }
}

struct CompositionalView: View {
    var body: some View {
        ViewControllerRepresentable {
            CompositionalViewController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    CompositionalView()
}
