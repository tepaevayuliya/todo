//
//  ValidationManager.swift
//  todo
//
//  Created by Юлия Тепаева on 09.11.2023.
//

import Foundation

enum ValidationManager {
    static func isValid(email: String?) -> Bool {
        let emailParameters = ".+@.+\\..+"
        return NSPredicate(format: "SELF MATCHES %@", emailParameters).evaluate(with: email)
    }

    static func isValid(commonText: String?, symbolsCount: Int) -> Bool {
        if let commonText {
            return commonText.count <= symbolsCount
        }
        return false
    }
}
