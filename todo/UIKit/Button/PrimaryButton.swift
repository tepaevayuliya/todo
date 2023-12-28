//
//  PrimaryButton.swift
//  todo
//
//  Created by Юлия Тепаева on 09.11.2023.
//

import UIKit

final class PrimaryButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(mode: Mode.large)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(mode: Mode.large)
    }

    enum Mode {
        case large
        case small
    }

    private lazy var buttonLoader: LoadingIndicatorImageView = {
        let loader = LoadingIndicatorImageView()
        loader.isHidden = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
            loader.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor),
            loader.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor),
        ])
        return loader
    }()

    func setup(mode: Mode) {
        if mode == Mode.large {
            style = Style(
                cornerRadius: 8,
                insets: 32,
                bgColor: .Color.primary,
                highlightedBgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                highlightedTitleColor: .Color.white
            )
            buttonLoader.image = UIImage.Common.loaderLarge
        } else if mode == Mode.small {
            style = Style(
                cornerRadius: 8,
                insets: 44,
                height: 34,
                bgColor: .Color.primary,
                highlightedBgColor: .Color.primary.withAlphaComponent(0.5),
                titleColor: .Color.white,
                highlightedTitleColor: .Color.white
            )
            buttonLoader.image = UIImage.Common.loaderSmall
        }
    }

    func setLoading(_ isLoading: Bool) {
        buttonLoader.isHidden = !isLoading
        titleLabel?.alpha = isLoading ? 0 : 1
        isUserInteractionEnabled = !isLoading
    }
}
