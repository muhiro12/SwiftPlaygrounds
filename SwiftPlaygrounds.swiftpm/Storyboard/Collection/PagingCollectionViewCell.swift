//
//  PagingCollectionViewCell.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import UIKit

final class PagingCollectionViewCell: UICollectionViewCell {
    private let collectionView = UICollectionView()

    func configure() {
        addSubview(collectionView)
        collectionView.frame = frame
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PagingCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let float = CGFloat((indexPath.row % 3) + 1) * 0.1
        cell.backgroundColor = .init(red: 1 - float, green: 1, blue: 0.5 + float, alpha: 1)
        cell.layer.cornerRadius = 4
        return cell
    }
}

extension PagingCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.bounds.size
    }
}
