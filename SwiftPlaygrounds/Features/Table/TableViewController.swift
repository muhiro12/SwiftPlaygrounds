//
//  TableViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

private struct TableDemoUser: Identifiable {
    enum Role: String {
        case design
        case engineering
        case product

        var color: UIColor {
            switch self {
            case .design:
                return .systemPink
            case .engineering:
                return .systemBlue
            case .product:
                return .systemGreen
            }
        }
    }

    let id: String
    let name: String
    let role: Role
    let likeCount: Int
    let dislikeCount: Int
}

final class TableViewController: UIViewController {
    private let tableView = UITableView()

    private let userList: [TableDemoUser] = [
        .init(id: "u1", name: "Alex", role: .design, likeCount: 14, dislikeCount: 2),
        .init(id: "u2", name: "Blake", role: .engineering, likeCount: 31, dislikeCount: 4),
        .init(id: "u3", name: "Casey", role: .product, likeCount: 22, dislikeCount: 1),
        .init(id: "u4", name: "Drew", role: .engineering, likeCount: 18, dislikeCount: 6),
        .init(id: "u5", name: "Evan", role: .design, likeCount: 11, dislikeCount: 3),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        tableView.frame = view.frame

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return .init()
        }

        let user = userList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = "+ \(user.likeCount), - \(user.dislikeCount)"
        content.image = UIImage(systemName: "circle")?.withTintColor(user.role.color, renderingMode: .alwaysOriginal)
        cell.contentConfiguration = content
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        let alertController = UIAlertController(
            title: user.name,
            message: user.role.rawValue.capitalized,
            preferredStyle: .alert
        )
        alertController.addAction(.init(title: "OK", style: .default) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        present(alertController, animated: true)
    }
}

struct TableView: View {
    var body: some View {
        ViewControllerRepresentable {
            TableViewController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    TableView()
}
