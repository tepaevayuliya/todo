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
    let deadline: Date
}

protocol NewItemViewControllerDelegate: AnyObject {
    func didSelect(_ vc: NewItemViewController, data: NewItemData)
}

final class NewItemViewController: ParentViewController {
    @IBOutlet private var textView: TextViewInput!
    @IBOutlet private var textView1: TextViewInput!
    @IBOutlet private var label: UILabel!
    @IBOutlet private var pick: UIDatePicker! //datePicker
    @IBOutlet private var createButton: PrimaryButton!

    weak var delegate: NewItemViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Main.emptyButton
        createButton.setTitle(L10n.Main.createButton, for: .normal)

        if let selectedItem {
            textView.set(text: selectedItem.title)
        }

    }

    @IBAction private func didTap() {
        delegate?.didSelect(self, data: NewItemData(title: "textView.text", description: "textView1.text", deadline: pick.date))
        navigationController?.popViewController(animated: true)
    }

    var selectedItem: MainDataItem?
}
