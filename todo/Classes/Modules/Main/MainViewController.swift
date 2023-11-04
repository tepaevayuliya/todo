//
//  MainViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 31.10.2023.
//

import UIKit

final class MainViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        emptyImageView.image = UIImage.Main.empty

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Main.title
        emptyLabel.text = L10n.Main.emptyLabel
        emptyButton.setTitle(L10n.Main.emptyButton, for: .normal)

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: L10n.Main.profileButton, style: .plain, target: self, action: nil)
    }

    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: UIButton!

    @IBAction private func didTabEmptyButton() {}
}
