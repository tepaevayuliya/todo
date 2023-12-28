//
//  ParentViewController.swift
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
        snackBarView.setup()
    }

    var snackBarView = SnackBarView()

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()

        snackBarView.errorLabelTopConstraint.constant = (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20) + 6
    }

    static func goToAuth() {
        UserManager.shared.reset()

        let storyboard = UIStoryboard(name: "Auth", bundle: nil)
        UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow }.last?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
