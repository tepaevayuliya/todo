//
//  TodosRequestBody.swift
//  todo
//
//  Created by Юлия Тепаева on 13.12.2023.
//

import Foundation

struct Coordinate: Encodable {
    let longitude: String
    let latitude: String
}

struct TodosRequestBody: Encodable {
    let category: String = ""
    let title: String
    let description: String
    let date: Date
    let coordinate: Coordinate = .init(longitude: "", latitude: "")
}
