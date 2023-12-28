//
//  MainManager.swift
//  todo
//
//  Created by Юлия Тепаева on 25.12.2023.
//

import Foundation

protocol MainManager {
    func getTodoList() async throws -> [TodosResponse]
    func toggleTodoMark(todoId: String) async throws -> EmptyResponse
}

extension NetworkManager: MainManager {
    func getTodoList() async throws -> [TodosResponse] {
        let todosResponse: [TodosResponse] = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "GET"
        )
        return todosResponse
    }

    func toggleTodoMark(todoId: String) async throws -> EmptyResponse {
        let todoMarkResponse: EmptyResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos/mark/\(todoId)",
            method: "PUT"
        )
        return todoMarkResponse
    }
}
