//
//  Data+.swift
//  todo
//
//  Created by Юлия Тепаева on 26.12.2023.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    } 
}
