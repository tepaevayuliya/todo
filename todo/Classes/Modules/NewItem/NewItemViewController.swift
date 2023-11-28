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
    @IBOutlet private var createButton: PrimaryButton!

    weak var delegate: NewItemViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Main.emptyButton
        createButton.setTitle(L10n.Main.createButton, for: .normal)
        label.text = L10n.NewItem.deadlineLabel
        textView.setup(text: "", titleText: L10n.NewItem.textViewTitleTask)
        textView1.setup(text: "", titleText: L10n.NewItem.textViewDescription)
    }

    @IBAction private func didTap() {
        Task {
            do {
                let bodeRequest = TodosResponseBody(category: "", title: self.textView.text ?? "", description: self.textView1.text ?? "", date: Int(self.pick.date.timeIntervalSince1970), coordinate: Coordinate(longitude: "", latitude: ""))

                _ = try await NetworkManagers.shared.request(url: "todos", metod: "POST", requestBody: bodeRequest, response: EmptyResponse(), isDateExpected: true, isRequestNil: false)

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
