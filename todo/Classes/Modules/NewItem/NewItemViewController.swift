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
    @IBOutlet private var textView: TextViewInput!
    @IBOutlet private var textView1: TextViewInput!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var pick: UIDatePicker!
    @IBOutlet private var viewDataPicker: UIView!
    @IBOutlet private var createButton: PrimaryButton!

    weak var delegate: NewItemViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Main.emptyButton
        createButton.setTitle(L10n.Main.createButton, for: .normal)
        label.text = L10n.NewItem.deadlineLabel
        textView.setup(text: "", titleText: L10n.NewItem.textViewTitleTask)
        textView1.setup(text: "", titleText: L10n.NewItem.textViewDescription)

        setup()
    }

    private func setup() {
        viewDataPicker.layer.cornerRadius = 13
        viewDataPicker.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        viewDataPicker.layer.shadowOpacity = 1
        viewDataPicker.layer.shadowRadius = 60
        viewDataPicker.layer.shadowOffset = CGSize(width: 0, height: 10)

        pick.layer.cornerRadius = 13
        pick.tintColor = UIColor.Color.lightRed
    }

    @IBAction private func didTap() {
        var isValidFlag = true

        if textView.text?.isEmpty ?? true {
            textView.show(error: L10n.NewItem.textFieldError)
            isValidFlag = false
        }

        if textView1.text?.isEmpty ?? true {
            textView1.show(error: L10n.NewItem.textFieldError)
            isValidFlag = false
        }

        if isValidFlag {
            Task {
                do {
                    let bodyRequest = TodosResponseBody(category: "", title: self.textView.text!, description: self.textView1.text!, date: Int(self.pick.date.timeIntervalSince1970), coordinate: Coordinate(longitude: "", latitude: ""))

                    _ = try await NetworkManagers.shared.request(urlPart: "todos", metod: "POST", requestBody: bodyRequest, response: EmptyResponse(), isRequestNil: false)

                    delegate?.didSelect(self)
                    navigationController?.popViewController(animated: true)
                } catch {
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть!", style: .cancel))
                    present(alertVC, animated: true)
                }
            }
        }
    }
}
