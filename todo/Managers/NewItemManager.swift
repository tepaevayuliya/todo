//
//  NewItemManager.swift
//  todo
//
//  Created by Юлия Тепаева on 25.12.2023.
//

import Foundation
import UIKit

protocol NewItemManager {
    func createNewTodo(title: String, description: String, date: Date) async throws -> TodosResponse
    func deleteTodo(todoId: String) async throws -> EmptyResponse
}

extension NetworkManager: NewItemManager {
    func createNewTodo(title: String, description: String, date: Date) async throws -> TodosResponse {
        let newItemData = TodosRequestBody(title: title, description: description, date: date)
        let newTodoResponse: TodosResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "POST",
            requestBody: newItemData
        )
        return newTodoResponse
    }

    func deleteTodo(todoId: String) async throws -> EmptyResponse {
        let deleteResponse: EmptyResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos/\(todoId)",
            method: "DELETE"
        )
        return deleteResponse
    }
}
