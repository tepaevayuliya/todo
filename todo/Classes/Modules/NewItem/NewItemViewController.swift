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
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var titleView: TextViewInput!
    @IBOutlet private var descriptionView: TextViewInput!
    @IBOutlet private var deadlineLabel: UILabel!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var viewDatePicker: UIView!
    @IBOutlet private var createButton: PrimaryButton!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var superView: UIView!

    weak var delegate: NewItemViewControllerDelegate?

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
            let button = UIButton(type: .custom)
            button.setTitle(L10n.NewItem.deleteButton, for: .normal)
            button.addTarget(self, action: #selector(deleteToDo), for: .touchUpInside)
            button.setTitleColor(UIColor.Color.error, for: .normal)

            let buttonItem = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = buttonItem

            navigationItem.title = L10n.NewItem.title

            titleView.set(text: selectedItem.title)
            descriptionView.set(text: selectedItem.description)
            datePicker.date = selectedItem.date

            createButton.heightAnchor.constraint(equalToConstant: 0).isActive = true
            createButtonTopConstraint.isActive = false
            scrollViewBottomConstraint.isActive = true
            createButton.isHidden = true
        } else {
            navigationItem.title = L10n.Main.emptyButton
            createButton.isHidden = false
            createButtonTopConstraint.isActive = true
            scrollViewBottomConstraint.isActive = false
        }
    }

    private lazy var createButtonTopConstraint = createButton.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0)
    private lazy var scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0)

    @objc 
    private func deleteToDo() {
        guard let itemId = selectedItem?.id else {
            return
        }
        Task {
            do {
                _ = try await NetworkManagers.shared.request(urlPart: "todos/\(itemId)", method: "DELETE") as EmptyResponse
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                view.window?.rootViewController = vc
            } catch {
                DispatchQueue.main.async {
                    self.showAlertVC(massage: error.localizedDescription)
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

                    let _: EmptyResponse = try await NetworkManagers.shared.request(urlPart: "todos", method: "POST", requestBody: requestBody)

                    delegate?.didSelect(self)
                    navigationController?.popViewController(animated: true)
                } catch {
                    DispatchQueue.main.async {
                        self.showAlertVC(massage: error.localizedDescription)
                    }
                }
            }
        }
    }

    var selectedItem: TodosResponse?
}
