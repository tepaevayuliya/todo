//
//  TextViewInput.swift
//  todo
//
//  Created by Юлия Тепаева on 14.11.2023.
//

import UIKit

final class TextViewInput: UIView, UITextViewDelegate {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .Color.black
        label.font = .systemFont(ofSize: 14)

        return label
    }()

    private lazy var textView: UITextView = {
        let textView = UITextView()

        textView.backgroundColor = .Color.BackgroundAndSurface.surfaceSecondary
        textView.textColor = .Color.black
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.tintColor = UIColor.Color.black
        textView.textContainerInset = UIEdgeInsets(top: 18, left: 16, bottom: 16, right: 16)

        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.isScrollEnabled = false

        return textView
    }()

    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        label.textColor = .Color.error
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 2

        return label
    }()

    var text: String? {
        textView.text
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

    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)

        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = min(max(estimatedSize.height, 56), 200)
                if constraint.constant == 200 {
                    textView.isScrollEnabled = true
                }
            }
        }
    }

    func setup(text: String?, titleText: String?) {
        textView.text = text
        titleLabel.text = titleText
    }

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

    private lazy var bottomConstraint = textView.bottomAnchor.constraint(equalTo: bottomAnchor)

    private func setup() {
        addSubview(titleLabel)
        addSubview(textView)
        addSubview(errorLabel)

        titleLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: frame.width,
                                  height: 22)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 56),

            bottomConstraint,

            errorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            errorLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @objc
    private func didBeginEditing() {
        hideError()
    }
}
