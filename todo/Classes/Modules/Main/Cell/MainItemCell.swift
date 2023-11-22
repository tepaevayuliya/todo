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
        updateImage()
    }

    override var isSelected: Bool {
        didSet {
            updateImage()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            view.alpha = isHighlighted ? 0.5 : 1
        }
    }

    private func formatted(deadline: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = L10n.Main.itemCellDateFormate
        return L10n.Main.itemDeadline + dateFormatter.string(from: deadline)
    }

    private func isDeadlinePassed(deadline: Date) -> Bool {
        return deadline < Date()
    }

    func setup(item: MainDataItem) {
        titleLabel.text = item.title
        if isDeadlinePassed(deadline: item.deadline) {
            deadline.textColor = .Color.red
        }
        deadline.text = formatted(deadline: item.deadline)
        view.layer.cornerRadius = 16
    }

    @IBOutlet private var view: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var deadline: UILabel!

    private func updateImage() {
        if isSelected {
            iconView.image = UIImage.ItemCell.radiobuttonOn
        } else {
            iconView.image = UIImage.ItemCell.radiobuttonOff
        }
    }
}
