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

    enum Error {
        case noConnection, otherError
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

    @IBOutlet private var stackView4: UIStackView!
    @IBOutlet private var stackView3: UIStackView!
    @IBOutlet private var stackView2: UIStackView!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var emptyImageView: UIImageView!
    @IBOutlet private var emptyLabel: UILabel!
    @IBOutlet private var emptyButton: PrimaryButton!

    private func updateState() {
        switch state {
        case .empty:
            emptyLabel.text = "Пока нет ни одной записи.\nСоздайте новую!"
            emptyImageView.image = UIImage.Main.empty
            emptyButton.setTitle("Новая запись", for: .normal)
            emptyButton.setup(mode: PrimaryButton.Mode.large)
            emptyButtonTopAnchor.isActive = false
            stackView4.alignment = .fill
            stackView4.spacing = 0
            stackView.alignment = .fill
            emptyButtonTrailingAnchor.isActive = true
            emptyButtonLeadingAnchor.isActive = true
        case let .error(error):
            switch error {
            case .noConnection:
                emptyLabel.text = "Нет соединения"
                emptyImageView.image = UIImage.Main.Error.noСonnection
                emptyButton.setTitle("Обновить", for: .normal)
                emptyButton.setup(mode: PrimaryButton.Mode.small)
                emptyButtonTopAnchor.isActive = true
                stackView4.alignment = .center
                stackView4.spacing = 16
                stackView.alignment = .center
                emptyButtonTrailingAnchor.isActive = false
                emptyButtonLeadingAnchor.isActive = false
            case .otherError:
                emptyLabel.text = "Что-то пошло не так"
                emptyImageView.image = UIImage.Main.Error.otherError
                emptyButton.setTitle("Обновить", for: .normal)
                emptyButton.setup(mode: PrimaryButton.Mode.small)
                emptyButtonTopAnchor.isActive = true
                stackView4.alignment = .center
                stackView4.spacing = 16
                stackView.alignment = .center
                emptyButtonTrailingAnchor.isActive = false
                emptyButtonLeadingAnchor.isActive = false
            }
        }
    }

    private lazy var emptyButtonTopAnchor = emptyButton.topAnchor.constraint(equalTo: stackView3.bottomAnchor, constant: 16)
    private lazy var emptyButtonTrailingAnchor = emptyButton.trailingAnchor.constraint(equalTo: stackView4.trailingAnchor)
    private lazy var emptyButtonLeadingAnchor = emptyButton.leadingAnchor.constraint(equalTo: stackView4.trailingAnchor)

    @IBAction private func didTabEmptyButton() {
        switch state {
        case .empty:
            action?()
        case .error(.noConnection), .error(.otherError):
            state = .empty
            viewDidLoad()
        }
    }
}
