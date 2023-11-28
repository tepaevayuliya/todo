//
//  TodosResponse.swift
//  todo
//
//  Created by Юлия Тепаева on 26.11.2023.
//

import Foundation

struct TodosResponse: Decodable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let isCompleted: Bool
}
