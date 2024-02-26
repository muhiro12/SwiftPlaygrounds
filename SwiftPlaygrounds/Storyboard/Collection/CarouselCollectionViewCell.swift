//
//  CarouselCollectionViewCell.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/27.
//

import UIKit

final class CarouselCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!

    func configure() {
        collectionView.dataSource = self

        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            guard let self else {
                return nil
            }

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(collectionView.bounds.width - 32 * 2),
                heightDimension: .fractionalHeight(1)
            )
            let group: NSCollectionLayoutGroup = .horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)

            section.orthogonalScrollingBehavior = .groupPagingCentered
            section.interGroupSpacing = 16

            return section
        }
    }
}

extension CarouselCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        let float = CGFloat((indexPath.row % 3) + 1) * 0.1
        cell.backgroundColor = .init(red: 0.5 + float, green: 1 - float, blue: 1, alpha: 1)
        return cell
    }
}
