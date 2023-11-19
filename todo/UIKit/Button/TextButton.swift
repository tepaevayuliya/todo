//
//  TextButton.swift
//  todo
//
//  Created by Юлия Тепаева on 13.11.2023.
//

import UIKit

final class TextButton: MainButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup(mode: Mode.normal)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(mode: Mode.normal)
    }

    enum Mode {
        case normal
        case destructive
    }

    func setup(mode: Mode) {
        if mode == Mode.normal {
            style = Style(
                font: .boldSystemFont(ofSize: 16),
                insets: 32,
                titleColor: .Color.black,
                highlightedTitleColor: .Color.black.withAlphaComponent(0.5)
            )
        } else if mode == Mode.destructive {
            style = Style(
                font: .boldSystemFont(ofSize: 16),
                insets: 32,
                titleColor: .Color.red,
                highlightedTitleColor: .Color.red.withAlphaComponent(0.5)
            )
        }
    }
}
