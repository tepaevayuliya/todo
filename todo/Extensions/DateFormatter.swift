//
//  DateFormatter.swift
//  todo
//
//  Created by Юлия Тепаева on 24.11.2023.
//

import UIKit

extension DateFormatter {
    static let `default` = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = L10n.Main.itemCellDateFormate

        return formatter
    }()
}
