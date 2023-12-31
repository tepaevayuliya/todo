//
//  NewItemViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 16.11.2023.
//

import UIKit
import Dip

struct NewItemData {
    let title: String
    let description: String
    let date: Date
    let isCompleted: Bool
}

enum ItemAction {
    case create
    case delete
}

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController, action: ItemAction, date: Date?)
}

final class NewItemViewController: ParentViewController {
    @Injected private var networkManager: NewItemManager!

    @IBOutlet private var titleView: TextViewInput!
    @IBOutlet private var descriptionView: TextViewInput!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var viewDatePicker: UIView!
    @IBOutlet private var createButton: PrimaryButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var superView: UIView!

    private lazy var createButtonTopConstraint = createButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
    @IBOutlet private var keyboardTopConstraint: NSLayoutConstraint!
    @IBOutlet private var keyboardScrollViewConstraint: NSLayoutConstraint!

    var selectedItem: TodosResponse?
    var selectedDate: Date?
    weak var delegate: NewItemViewControllerDelegate?

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        createButton.setTitle(L10n.Main.createButton, for: .normal)

        deadlineLabel.text = L10n.NewItem.deadlineLabel
        titleView.setup(text: "", titleText: L10n.NewItem.textViewTitleTask)
        descriptionView.setup(text: "", titleText: L10n.NewItem.textViewDescription)

        viewDatePicker.layer.cornerRadius = 13
        viewDatePicker.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        viewDatePicker.layer.shadowOpacity = 1
        viewDatePicker.layer.shadowRadius = 60
        viewDatePicker.layer.shadowOffset = CGSize(width: 0, height: 10)

        datePicker.layer.cornerRadius = 13
        datePicker.tintColor = UIColor.Color.lightRed

        addTapToHideKeyboardGesture()

        if let selectedDate {
            datePicker.date = selectedDate
        }

        if let selectedItem {
            let button = UIButton(type: .system)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.setTitle(L10n.EditItem.deleteButton, for: .normal)
            button.addTarget(self, action: #selector(deleteToDo), for: .touchUpInside)
            button.setTitleColor(UIColor.Color.error, for: .normal)

            let buttonItem = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = buttonItem

            navigationItem.title = L10n.EditItem.title

            titleView.set(text: selectedItem.title)
            descriptionView.set(text: selectedItem.description)
            datePicker.date = selectedItem.date

            createButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
            createButtonTopConstraint.isActive = false
            keyboardScrollViewConstraint.isActive = true
            keyboardTopConstraint.isActive = false

            createButton.isHidden = true
        } else {
            navigationItem.title = L10n.Main.emptyButton
            createButton.isHidden = false

            createButtonTopConstraint.isActive = true
            keyboardScrollViewConstraint.isActive = false
            keyboardTopConstraint.isActive = true
        }
    }

    @objc
    private func deleteToDo() {
        guard let itemId = selectedItem?.id else {
            return
        }
        Task {
            do {
                _ = try await networkManager.deleteTodo(todoId: itemId)

                delegate?.didSelect(self, action: .delete, date: nil)
                navigationController?.popViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction private func createToDo() {
        var isValidFlag = true

        if titleView.text?.isEmpty ?? true {
            titleView.show(error: L10n.NewItem.textFieldError)
            isValidFlag = false
        }

        if descriptionView.text?.isEmpty ?? true {
            descriptionView.show(error: L10n.NewItem.textFieldError)
            isValidFlag = false
        }

        if isValidFlag {
            createButton.setLoading(true)
            Task {
                do {
                    _ = try await networkManager.createNewTodo(title: titleView.text ?? "", description: descriptionView.text ?? "", date: datePicker.date)

                    delegate?.didSelect(self, action: .create, date: datePicker.date)
                    navigationController?.popViewController(animated: true)
                } catch {
                    DispatchQueue.main.async {
                        self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                    }
                }
                createButton.setLoading(false)
            }
        }
    }
}
