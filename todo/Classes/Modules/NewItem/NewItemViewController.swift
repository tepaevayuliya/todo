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

    weak var delegate: NewItemViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Main.emptyButton
        createButton.setTitle(L10n.Main.createButton, for: .normal)

        deadlineLabel.text = L10n.NewItem.deadlineLabel
        titleView.setup(text: "", titleText: L10n.NewItem.textViewTitleTask)
        descriptionView.setup(text: "", titleText: L10n.NewItem.textViewDescription)

        if let selectedItem {
            titleView.set(text: selectedItem.title)
        }
      
        setup()
    }

    private func setup() {
        viewDatePicker.layer.cornerRadius = 13
        viewDatePicker.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        viewDatePicker.layer.shadowOpacity = 1
        viewDatePicker.layer.shadowRadius = 60
        viewDatePicker.layer.shadowOffset = CGSize(width: 0, height: 10)

        datePicker.layer.cornerRadius = 13
        datePicker.tintColor = UIColor.Color.lightRed

        addTapToHideKeyboardGesture()

        if let selectedItem {
            titleView.set(text: selectedItem.title)
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
