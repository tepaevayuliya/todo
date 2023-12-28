//
//  SnackBarView.swift
//  todo
//
//  Created by Юлия Тепаева on 22.12.2023.
//

import UIKit

final class SnackBarView: UIView {
    private var count = 0
    private let errorView = UIView()
    private let errorLabel = UILabel()
    private let errorButton = UIButton(type: .custom)
    lazy var errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 6)

    func setup() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorButton.translatesAutoresizingMaskIntoConstraints = false

        errorView.addSubview(errorLabel)
        errorView.backgroundColor = UIColor.Color.grey1

        errorLabelTopConstraint.isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: errorView.bottomAnchor, constant: -20).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: errorView.leadingAnchor, constant: 16).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: errorView.trailingAnchor, constant: -16).isActive = true

        errorLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        errorLabel.numberOfLines = 3
        errorLabel.textColor = UIColor.Color.white
        errorLabel.textAlignment = NSTextAlignment.center

        errorView.addSubview(errorButton)
        errorButton.topAnchor.constraint(equalTo: errorView.topAnchor).isActive = true
        errorButton.bottomAnchor.constraint(equalTo: errorView.bottomAnchor).isActive = true
        errorButton.leadingAnchor.constraint(equalTo: errorView.leadingAnchor).isActive = true
        errorButton.trailingAnchor.constraint(equalTo: errorView.trailingAnchor).isActive = true

        errorButton.addTarget(self, action: #selector(hideSnackBar), for: .touchUpInside)
    }

    func showSnackbarVC(message: String) {
        count += 1
        errorView.removeFromSuperview()

        guard let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last else {
            return
        }

        window.addSubview(errorView)
        errorView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
        errorView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
        errorView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true

        errorLabel.text = message

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            if self?.count == 1 {
                self?.errorView.removeFromSuperview()
            }
            self?.count -= 1
        }
    }

    @objc
    private func hideSnackBar() {
        errorView.removeFromSuperview()
    }
}
