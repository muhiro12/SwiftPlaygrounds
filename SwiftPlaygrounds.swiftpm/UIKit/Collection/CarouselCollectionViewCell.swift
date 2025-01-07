//
//  CarouselCollectionViewCell.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/27.
//

import UIKit

final class CarouselCollectionViewCell: UICollectionViewCell {
    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )

    func configure() {
        addSubview(collectionView)
        collectionView.frame = frame

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

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

extension CarouselCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let float = CGFloat((indexPath.row % 3) + 1) * 0.1
        cell.backgroundColor = .init(red: 0.5 + float, green: 1 - float, blue: 1, alpha: 1)
        cell.layer.cornerRadius = 4
        return cell
    }
}
