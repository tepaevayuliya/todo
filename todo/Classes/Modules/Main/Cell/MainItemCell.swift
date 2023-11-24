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

    private func isDeadlinePassed(deadline: Date) -> Bool {
        deadline < Date()
    }

    func setup(item: MainDataItem) {
        titleLabel.text = item.title
        deadline.textColor = isDeadlinePassed(deadline: item.deadline) ? .Color.red : .Color.black

        deadline.text = DateFormatter.default.string(from: item.deadline)
        view.layer.cornerRadius = 16
    }

    @IBOutlet private var view: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var deadline: UILabel!

    private func updateImage() {
        iconView.image = isSelected ? UIImage.ItemCell.radiobuttonOn : UIImage.ItemCell.radiobuttonOff
    }
}
