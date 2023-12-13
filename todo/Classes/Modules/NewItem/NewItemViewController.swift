//
//  NewItemViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 16.11.2023.
//

import UIKit

struct NewItemData {
    let title: String
    let description: String
    let date: Date
    let isCompleted: Bool
}

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController)
}

final class NewItemViewController: ParentViewController {
    @IBOutlet private var titleView: TextViewInput!
    @IBOutlet private var descriptionView: TextViewInput!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var viewDatePicker: UIView!
    @IBOutlet private var createButton: PrimaryButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var superView: UIView!

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

    private lazy var createButtonTopConstraint = createButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
    @IBOutlet private var keyboardTopConstraint: NSLayoutConstraint!
    @IBOutlet private var keyboardScrollViewConstraint: NSLayoutConstraint!

    @objc
    private func deleteToDo() {
        guard let itemId = selectedItem?.id else {
            return
        }
        Task {
            do {
                _ = try await NetworkManager.shared.requestWithoutRequestBody(urlPart: "todos/\(itemId)", method: "DELETE") as EmptyResponse

                delegate?.didSelect(self)
                navigationController?.popViewController(animated: true)
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbarVC(message: error.localizedDescription)
                }
            }
        }
    }

    @IBAction private func didTap() {
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
            Task {
                do {
                    let requestBody = TodosRequestBody(title: self.titleView.text ?? "", description: self.descriptionView.text ?? "", date: self.datePicker.date)

                    let _: EmptyResponse = try await NetworkManager.shared.requestWithRequestBody(urlPart: "todos", method: "POST", requestBody: requestBody)

                    delegate?.didSelect(self)
                    navigationController?.popViewController(animated: true)
                } catch {
                    DispatchQueue.main.async {
                        self.showSnackbarVC(message: error.localizedDescription)
                    }
                }
            }
        }
    }

    var selectedItem: TodosResponse?
}
