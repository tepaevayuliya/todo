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
    }

    func showAlertVC(massage: String) {
        let alertVC = UIAlertController(title: L10n.NetworkError.alertTitle, message: massage, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: L10n.NetworkError.alertButton, style: .cancel))
        present(alertVC, animated: true)
    }
}
