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
        case horizontalScroll
        case verticalScroll
    }

    var isParent = true
    var scrollDirection = UICollectionView.ScrollDirection.vertical

    @IBOutlet private weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = scrollDirection
        }

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .simple: 8
        case .pallet: 8
        case .horizontalScroll: 1
        case .verticalScroll: 1
        case .none: .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let section = Section(rawValue: indexPath.section)

        let addChild: (Bool) -> Void = {
            let vc = UIStoryboard(name: "Collection", bundle: nil).instantiateInitialViewController()! as CollectionViewController
            vc.isParent = false
            vc.scrollDirection = $0 ? .vertical : .horizontal

            self.addChild(vc)

            let view = vc.view!
            view.translatesAutoresizingMaskIntoConstraints = false

            let cellView = cell.contentView

            cellView.addSubview(view)
            cellView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            cellView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            cellView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
            cellView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }

        switch section {
        case .simple:
            cell.backgroundColor = .init(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        case .pallet:
            cell.backgroundColor = .init(red: 0.5, green: 1, blue: 0.5, alpha: 1)
        case .horizontalScroll:
            cell.backgroundColor = .init(red: 0.5, green: 0.5, blue: 1, alpha: 1)
            if isParent {
                addChild(false)
            }
        case .verticalScroll:
            cell.backgroundColor = .init(red: 1, green: 1, blue: 0.5, alpha: 1)
            if isParent {
                addChild(true)
            }
        case .none:
            break
        }
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let parentSize = collectionView.window?.windowScene?.screen.bounds.size ?? .zero
        switch Section(rawValue: indexPath.section) {
        case .simple: return .init(width: parentSize.width, height: 40)
        case .pallet: return .init(width: (parentSize.width / 4) - 3 * 8, height: 40)
        case .horizontalScroll: return .init(width: parentSize.width, height: 120)
        case .verticalScroll: return .init(width: parentSize.width, height: 400)
        case .none: return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard section != 0 else {
            return .zero
        }
        return .init(width: .zero, height: 40)
    }
}

struct CollectionView: View {
    var body: some View {
        ViewControllerRepresentable("Collection")
            .ignoresSafeArea()
    }
}

#Preview {
    CollectionView()
}
