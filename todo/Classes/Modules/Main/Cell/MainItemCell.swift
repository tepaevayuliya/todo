//
//  MainItemCell.swift
//  todo
//
//  Created by Юлия Тепаева on 15.11.2023.
//

import UIKit

final class MainItemCell: UICollectionViewCell {
    static let reuseID = String(describing: MainItemCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()

        iconButton.setImage(UIImage.ItemCell.radiobuttonOn, for: .selected)
        iconButton.setImage(UIImage.ItemCell.radiobuttonOff, for: .normal)
    }

    override var isHighlighted: Bool {
        didSet {
            view.alpha = isHighlighted ? 0.5 : 1
        }
    }

    private func isDeadlinePassed(deadline: Date) -> Bool {
        deadline < Date()
    }

    func setup(item: TodosResponse, action: @escaping () -> Void) {
        titleLabel.text = item.title
        deadline.textColor = isDeadlinePassed(deadline: item.date) ? .Color.red : .Color.black
        iconButton.tintColor = UIColor.clear

        deadline.text = DateFormatter.default.string(from: item.date)
        view.layer.cornerRadius = 16
        iconButton.isSelected = item.isCompleted
        self.action = action
    }
    
    private var action: (() -> Void)?

    @IBAction private func didTapButton() {
        action?()
    }

    @IBOutlet private var iconButton: UIButton!
    @IBOutlet private var view: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var deadline: UILabel!
}
