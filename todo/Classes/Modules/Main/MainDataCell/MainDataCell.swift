//
//  MainDataCell.swift
//  todo
//
//  Created by Юлия Тепаева on 07.12.2023.
//

import UIKit

final class MainDataCell: UICollectionViewCell {
    static let reuseID = String(describing: MainDataCell.self)

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor.Color.BackgroundAndSurface.surfaceSecondary
        contentView.layer.cornerRadius = 4
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.Color.Text.textSecondary : UIColor.Color.BackgroundAndSurface.surfaceSecondary
        }
    }

    func setup(title: String) {
        titleLabel.text = title
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
