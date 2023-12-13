//
//  ParenyViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    deinit {
        print("\(String(describing: type(of: self))) released")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonDisplayMode = .minimal
        setup()
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        errorLabelTopConstraint.constant = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20) + 6
    }

    private var count = 0
    private let errorView = UIView()
    private let errorLabel = UILabel()
    private lazy var errorLabelTopConstraint = errorLabel.topAnchor.constraint(equalTo: errorView.topAnchor, constant: 6)

    private func setup() {
        if let window = UIApplication.shared.connectedScenes.compactMap({ ($0 as? UIWindowScene)?.keyWindow }).last {
            window.addSubview(errorView)
            errorView.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
            errorView.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
            errorView.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
        }

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
    }

    static func goToAuth() {
        UserManager.shared.reset()

        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController = storyboard.instantiateInitialViewController()
    }

    func showSnackbarVC(message: String) {
        count += 1
        errorView.isHidden = false
        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = false

        errorLabel.text = message

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            if self?.count == 1 {
                self?.errorView.isHidden = true
            }
            self?.count -= 1
        }
    }
}
