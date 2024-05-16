//
//  CollectionViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

final class CollectionViewController: UIViewController {
    enum Section: Int, CaseIterable {
        case simple
        case pallet
        case carousel
        case paging
    }

    private let collectionView = UICollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.frame = view.frame
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
        switch section {
        case .simple:
            return 8
        case .pallet:
            return 8
        case .carousel:
            return 1
        case .paging:
            return 1
        case .none:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)

        let cell = {
            collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        }
        let carouselCell = {
            collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath) as! CarouselCollectionViewCell
        }
        let pagingCell = {
            collectionView.dequeueReusableCell(withReuseIdentifier: "PagingCell", for: indexPath) as! PagingCollectionViewCell
        }

        switch section {
        case .simple:
            let cell = cell()
            cell.backgroundColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
            cell.layer.cornerRadius = 4
            return cell
        case .pallet:
            let cell = cell()
            cell.backgroundColor = .init(red: 0.5, green: 1, blue: 0.5, alpha: 1)
            cell.layer.cornerRadius = 4
            return cell
        case .carousel:
            let cell = carouselCell()
            cell.backgroundColor = .init(red: 0.5, green: 1, blue: 1, alpha: 1)
            cell.layer.cornerRadius = 4
            cell.configure()
            return cell
        case .paging:
            let cell = pagingCell()
            cell.backgroundColor = .init(red: 1, green: 1, blue: 0.5, alpha: 1)
            cell.layer.cornerRadius = 4
            cell.configure()
            return cell
        case .none:
            let cell = cell()
            return cell
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = Section(rawValue: indexPath.section)

        let width: (CGFloat) -> CGFloat = {
            round((collectionView.bounds.width - ($0 - 1) * 16) / $0)
        }

        switch section {
        case .simple:
            return .init(width: width(1), height: 40)
        case .pallet:
            return .init(width: width(4), height: 40)
        case .carousel:
            return .init(width: width(1), height: 240)
        case .paging:
            return .init(width: width(1), height: 240)
        case .none:
            return .zero
        }
    }
}

struct CollectionView: View {
    var body: some View {
        ViewControllerRepresentable(CollectionViewController())
            .ignoresSafeArea()
    }
}

#Preview {
    CollectionView()
}
