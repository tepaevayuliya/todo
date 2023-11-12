//
//  MainButton.swift
//  todo
//
//  Created by Юлия Тепаева on 09.11.2023.
//

import UIKit

class MainButton: UIButton {
    struct Style {
        var cornerRadius: CGFloat = 0
        var font: UIFont = .systemFont(ofSize: 16)
        var insets: CGFloat = 0
        var heights: CGFloat = 56

        var bgColor: UIColor = .clear
        var highlightedBgColor : UIColor = .clear

        var titleColor: UIColor = .clear
        var highlightedTitleColor : UIColor = .clear
    }

    var style: Style = Style() {
        didSet {
            configureStyle()
        }
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
        CGSize(width: super.intrinsicContentSize.width + style.insets, height: style.heights)
    }

    private func setup() {
        configuration = .plain()
        configuration?.titleLineBreakMode = .byTruncatingTail
        configuration?.baseBackgroundColor = nil
        configuration?.cornerStyle = .fixed
    }

    private func configureStyle() {
        configuration?.background.cornerRadius = style.cornerRadius
        configuration?.background.backgroundColor = style.bgColor

        configurationUpdateHandler = { [weak self] button in
            guard let self else {
                return
            }

            var config = button.configuration
            let (titleColor, bgColor) = colors(for: button)
            config?.background.backgroundColor = bgColor
            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer{ [weak self] attr in
                var newAttr = attr
                newAttr.foregroundColor = titleColor
                return newAttr
            }
            button.tintColor = titleColor
            button.alpha = button.isEnabled ? 1 : 0.5
            button.configuration = config
        }
    }

    private func colors(for button: UIButton) -> (fgColor: UIColor, bgColor: UIColor) {
        if button.isHighlighted {
            return (fgColor: style.highlightedTitleColor, bgColor: style.highlightedBgColor)
        }
        return (fgColor: style.highlightedBgColor, bgColor: style.highlightedTitleColor)
    }
}
