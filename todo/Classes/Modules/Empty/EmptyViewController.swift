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

//    enum Error {
//        case noConnection, otherError
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateState()
        emptyButton.addAction(.init(handler: { [weak self] _ in self?.action?() }), for: .touchUpInside)
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
//            switch error {
//            case .noConnection:
//                emptyLabel.text = L10n.Empty.emptyLabelNoConnection
//                emptyImageView.image = UIImage.Main.Error.noСonnection
//            case .otherError:
//                emptyLabel.text = L10n.Empty.emptyLabelOtherError
//                emptyImageView.image = UIImage.Main.Error.otherError
//            }
        }
    }

    @IBAction private func didTabEmptyButton() {
        action?()
//        switch state {
//        case .empty:
//            action?()
//        case .error(.noConnection), .error(.otherError):
//            
//            updateState()
        }
    }
}
