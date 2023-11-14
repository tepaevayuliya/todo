//
//  TextViewInput.swift
//  todo
//
//  Created by Юлия Тепаева on 14.11.2023.
//

import UIKit

final class TextViewInput: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.isHidden = true
        label.textColor = UIColor.Color.black
        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 2

        return label
    }()

    private lazy var textField: TextField = {
        let textField = TextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        return textField
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = UIColor.Color.error
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 2

        return label
    }()

    var text: String? {
        textField.text
    }

    var titleText: String? {
        titleLabel.text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override var intrinsicContentSize: CGSize {
        let height: CGFloat = 56
        if errorLabel.isHidden {
            return CGSize(width: UIView.noIntrinsicMetric, height: height)
        }
        let rect = errorLabel.textRect(forBounds: bounds, limitedToNumberOfLines: errorLabel.numberOfLines)
        return CGSize(width: UIView.noIntrinsicMetric, height: height + rect.height + 4)
    }

    func setup(placeholder: String?, text: String?) {
        textField.placeholder = placeholder
        textField.text = text
    }

    func show1(titleText: String) {
        titleLabel.text = titleText
    }
//    func setup(placeholder: String?, text: String?, titleText: String?) {
//        textField.placeholder = placeholder
//        textField.text = text
//        titleLabel.text = titleText
//    }

    func show(error: String) {
        errorLabel.text = error
        bottomConstraint.isActive = false
        errorLabel.isHidden = false
        invalidateIntrinsicContentSize()
    }

    func hideError() {
        errorLabel.isHidden = true
        bottomConstraint.isActive = true
        invalidateIntrinsicContentSize()
    }

    func enableSecurityMode() {
        textField.enableSecurityMode()
    }

    private lazy var bottomConstraint = textField.bottomAnchor.constraint(equalTo: bottomAnchor)

    private func setup() {
        addSubview(titleLabel)
        addSubview(textField)
        addSubview(errorLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),

            bottomConstraint,

            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc
    private func didBeginEditing() {
        hideError()
    }
}
