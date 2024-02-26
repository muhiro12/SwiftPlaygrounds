//
//  TableViewController.swift
//  SwiftPlaygrounds
//
//  Created by Hiromu Nakano on 2024/02/26.
//

import SwiftUI

final class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let userList = UserListRequest().expected

    override func viewDidLoad() {
        super.viewDidLoad()
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
            return UITableViewCell()
        }
        let user = userList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = "+ \(user.likeCount), - \(user.dislikeCount)"
        content.image = .init(systemName: "circle")?.withTintColor(UIColor(user.gender.color), renderingMode: .alwaysOriginal)
        cell.contentConfiguration = content
        return cell
    }
}

extension TableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userList[indexPath.row]
        let alert = UIAlertController(title: user.name, message: user.gender.rawValue, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default) { _ in
            tableView.deselectRow(at: indexPath, animated: true)
        })
        present(alert, animated: true)
    }
}

struct TableView: View {
    var body: some View {
        ViewControllerRepresentable("Table")
            .ignoresSafeArea()
    }
}

#Preview {
    TableView()
}
