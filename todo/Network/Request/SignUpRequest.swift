//
//  SignUpRequest.swift
//  todo
//
//  Created by Юлия Тепаева on 03.12.2023.
//

import Foundation

struct SignUpRequestBody: Encodable {
    let name: String
    let email: String
    let password: String
}
