//
//  AuthResponse.swift
//  todo
//
//  Created by Юлия Тепаева on 23.11.2023.
//

import Foundation

struct AuthResponseStruct: Decodable {
    var accessToken = ""
}

var responseToken = AuthResponseStruct()
