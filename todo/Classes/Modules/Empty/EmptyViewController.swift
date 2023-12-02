//
//  EmptyViewController.swift
//  MyAwesomeSchoolApp
//
//  Created by Юлия Тепаева on 14.11.2023.
//

import UIKit

final class EmptyViewController: ParentViewController {
    enum State {
        case empty, error(Error)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateState()
    }

    var action: (() -> Void)?

    var state: State = .empty {
        didSet {
            guard view.window != nil else {
                return
            }
            updateState()
        }
    }

    @IBOutlet private var stackView3: UIStackView!
    @IBOutlet private var stackView2: UIStackView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!

    private func updateState() {
        switch state {
        case .empty:
            emptyLabel.text = L10n.Empty.emptyLabel
            emptyImageView.image = UIImage.Main.empty
            emptyButton.setTitle(L10n.Empty.emptyButton, for: .normal)
            emptyButton.setup(mode: PrimaryButton.Mode.large)

            stackView2.alignment = .fill
            stackView.alignment = .fill
        case let .error(error):
            stackView2.alignment = .center
            stackView.alignment = .center

            emptyButton.setTitle(L10n.Empty.emptyButtonError, for: .normal)
            emptyButton.setup(mode: PrimaryButton.Mode.small)

            if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                emptyLabel.text = L10n.Empty.emptyLabelNoConnection
                emptyImageView.image = UIImage.Main.Error.noСonnection
            } else {
                emptyLabel.text = L10n.Empty.emptyLabelOtherError
                emptyImageView.image = UIImage.Main.Error.otherError
            }
        }
    }

    @IBAction private func didTapEmptyButton() {
        action?()
    }
}
