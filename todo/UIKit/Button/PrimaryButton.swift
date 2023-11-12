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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        style = Style(cornerRadius: 8, 
                      insets: 32,
                      bgColor: .Color.primary,
                      highlightedBgColor: .Color.primary.withAlphaComponent(0.5),
                      titleColor: .Color.white
                      //highlightedTitleColor: .Color.white.withAlphaComponent(0.5) // мб не так
        )
    }
}
