//
//  MainItemCell.swift
//  todo
//
//  Created by Юлия Тепаева on 15.11.2023.
//

import UIKit

final class MainItemCell: UICollectionViewCell {
    static let reuseID = String(describing: MainItemCell.self)

    override var isHighlighted: Bool {
        didSet {
            view.alpha = isHighlighted ? 0.5 : 1
        }
    }

    private func isDeadlinePassed(deadline: Date) -> Bool {
        deadline < Date()
    }

    func setup(item: TodosResponse) {
        titleLabel.text = item.title
        date.textColor = isDeadlinePassed(deadline: item.date) ? .Color.red : .Color.black
        iconView.image = item.isCompleted ? UIImage.ItemCell.radiobuttonOn : UIImage.ItemCell.radiobuttonOff

        date.text = DateFormatter.default.string(from: item.date)
        view.layer.cornerRadius = 16
    }

    @IBOutlet private var view: UIView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var iconView: UIImageView!
    @IBOutlet private var date: UILabel! //deadline
}
