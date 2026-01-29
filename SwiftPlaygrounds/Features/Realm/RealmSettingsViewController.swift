//
//  RealmSettingsViewController.swift
//  SwiftPlaygrounds
//
//  Created by Codex on 2026/01/29.
//

import SwiftUI
import UIKit

final class RealmSettingsViewController: UIViewController {
    private let userId = "demo_user"
    private let keyField = UITextField()
    private let valueField = UITextField()
    private let outputView = UITextView()
    private let addOrUpdateButton = UIButton(type: .system)
    private let removeButton = UIButton(type: .system)
    private let readAllButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Realm Settings"

        keyField.placeholder = "key (e.g. theme)"
        keyField.borderStyle = .roundedRect
        keyField.autocapitalizationType = .none
        keyField.autocorrectionType = .no

        valueField.placeholder = "value (e.g. dark)"
        valueField.borderStyle = .roundedRect
        valueField.autocapitalizationType = .none
        valueField.autocorrectionType = .no

        addOrUpdateButton.setTitle("Add / Update", for: .normal)
        addOrUpdateButton.addTarget(self, action: #selector(addOrUpdateTapped), for: .touchUpInside)

        removeButton.setTitle("Remove", for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        readAllButton.setTitle("Read All", for: .normal)
        readAllButton.addTarget(self, action: #selector(readAllTapped), for: .touchUpInside)

        outputView.isEditable = false
        outputView.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        outputView.layer.borderWidth = 1
        outputView.layer.borderColor = UIColor.separator.cgColor
        outputView.layer.cornerRadius = 8
        outputView.text = "Ready.\n"

        let buttonRow = UIStackView(arrangedSubviews: [addOrUpdateButton, removeButton, readAllButton])
        buttonRow.axis = .horizontal
        buttonRow.spacing = 12
        buttonRow.distribution = .fillEqually

        let stack = UIStackView(arrangedSubviews: [keyField, valueField, buttonRow, outputView])
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            outputView.heightAnchor.constraint(equalToConstant: 200)
        ])

        readAllTapped()
    }

    @objc private func addOrUpdateTapped() {
        let key = keyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let value = valueField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !key.isEmpty else {
            appendOutput("Key is empty.")
            return
        }

        let isNew = RealmManager.shared.addOrUpdateSetting(userId: userId, key: key, value: value)
        appendOutput("Add/Update: key=\(key), value=\(value), isNew=\(isNew)")
        readAllTapped()
    }

    @objc private func removeTapped() {
        let key = keyField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !key.isEmpty else {
            appendOutput("Key is empty.")
            return
        }

        let removed = RealmManager.shared.removeSetting(userId: userId, key: key)
        appendOutput("Remove: key=\(key), removed=\(removed)")
        readAllTapped()
    }

    @objc private func readAllTapped() {
        let current = RealmManager.shared.allSettings(userId: userId)
        appendOutput("All: \(current)")
    }

    private func appendOutput(_ text: String) {
        outputView.text += text + "\n"
        let range = NSRange(location: outputView.text.count - 1, length: 0)
        outputView.scrollRangeToVisible(range)
    }
}

struct RealmSettingsView: View {
    var body: some View {
        ViewControllerRepresentable {
            RealmSettingsViewController()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    RealmSettingsView()
}
