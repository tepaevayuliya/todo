//
//  ProfileResponseBody.swift
//  todo
//
//  Created by Юлия Тепаева on 08.12.2023.
//

import Foundation

struct ProfileResponseBody: Decodable {
    let name: String
    let email: String
    let imageId: String
}
