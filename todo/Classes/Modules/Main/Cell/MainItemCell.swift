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

    func formatted(deadline: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy в hh:mm"
        let deadlineText = "Дедлайн: " + dateFormatter.string(from: deadline)
        return deadlineText
    }

    func isUntilToday(deadline: Date) -> Bool {
        return deadline < Date()
    }

    func setup(item: MainDataItem) {
        titleLabel.text = item.title
        iconView.image = UIImage.ItemCell.radiobuttonOff
        if isUntilToday(deadline: item.deadline) {
            deadline.textColor = .red
        }
        deadline.text = formatted(deadline: item.deadline)
        view.layer.cornerRadius = 16
    }

    @IBOutlet var view: UIView!
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
