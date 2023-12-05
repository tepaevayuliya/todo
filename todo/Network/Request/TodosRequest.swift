//
//  TodosRequestBody.swift
//  todo
//
//  Created by Юлия Тепаева on 03.12.2023.
//

import Foundation

struct TodosRequestBody: Encodable {
    let category: String = ""
    let title: String
    let description: String
    let date: Date
    let coordinate: Coordinate = Coordinate(longitude: "", latitude: "")
}

struct Coordinate: Encodable {
    let longitude: String
    let latitude: String
}
