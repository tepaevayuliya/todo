//
//  SignInRequest.swift
//  todo
//
//  Created by Юлия Тепаева on 03.12.2023.
//

import Foundation

struct SignInRequestBody: Encodable {
    let email: String
    let password: String
}
