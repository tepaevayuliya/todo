//
//  NetworkManager.swift
//  todo
//
//  Created by Юлия Тепаева on 23.11.2023.
//

import Combine
import Foundation

enum NetworkError: LocalizedError {
    case wrongStatusCode, wrongURL, wrongResponse, expiredToken

    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return L10n.NetworkError.wrongStatusCode
        case .wrongURL:
            return L10n.NetworkError.wrongUrl
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        case .expiredToken:
            return L10n.NetworkError.expiredToken
        }
    }
}

final class NetworkManager {
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(decoder: JSONDecoder, encoder: JSONEncoder) {
        self.decoder = decoder
        self.encoder = encoder
    }

    static let shared = NetworkManager(decoder: {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970

        return decoder
    }(), encoder: {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970

        return encoder
    }())

    struct EmptyEncodable: Encodable {}

    func request<Response: Decodable>(urlPart: String, method: String) async throws -> Response {
        try await request(urlPart: urlPart, method: method, requestBody: EmptyEncodable?.none)
    }

    func request<Request: Encodable, Response: Decodable>(
        urlPart: String,
        method: String,
        requestBody: Request?
    ) async throws -> Response {
        guard let url = URL(string: urlPart) else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let requestBody {
            request.httpBody = try encoder.encode(requestBody)
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let accessToken = UserManager.shared.accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }

        let (data, resp) = try await URLSession.shared.data(for: request)
        log.debug("\(data)")
        if let httpResponse = resp as? HTTPURLResponse {
            let response = String(data: data, encoding: .utf8) ?? ""
            log.debug("\(response)")
            switch httpResponse.statusCode {
            case 200 ..< 400:
                if data.isEmpty, let emptyData = "{}".data(using: .utf8) {
                    return try decoder.decode(Response.self, from: emptyData)
                }
                return try decoder.decode(DataResponse<Response>.self, from: data).data
            case 401:
                await ParentViewController.goToAuth()
                throw NetworkError.expiredToken
            default:
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }

    func signIn(email: String, password: String) async throws -> AuthResponse {
        let signInData = SignInRequestBody(email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/auth/login",
            method: "POST",
            requestBody: signInData
        )
        UserManager.shared.set(accessToken: authResponse.accessToken)
        return authResponse
    }

    func signUp(name: String, email: String, password: String) async throws -> AuthResponse {
        let signUpData = SignUpRequestBody(name: name, email: email, password: password)
        let authResponse: AuthResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/auth/registration",
            method: "POST",
            requestBody: signUpData
        )
        UserManager.shared.set(accessToken: authResponse.accessToken)
        return authResponse
    }

    func getTodoList() async throws -> [TodosResponse] {
        let todosResponse: [TodosResponse] = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "GET"
        )
        return todosResponse
    }

    func createNewTodo(title: String, description: String, date: Date) async throws -> TodosResponse {
        let newItemData = TodosRequestBody(title: title, description: description, date: date)
        let newTodoResponse: TodosResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos",
            method: "POST",
            requestBody: newItemData
        )
        return newTodoResponse
    }

    func toggleTodoMark(todoId: String) async throws -> EmptyResponse {
        let todoMarkResponse: EmptyResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos/mark/\(todoId)",
            method: "PUT"
        )
        return todoMarkResponse
    }

    func deleteTodo(todoId: String) async throws -> EmptyResponse {
        let deleteResponse: EmptyResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/todos/\(todoId)",
            method: "DELETE"
        )
        return deleteResponse
    }

    func getUserProfile() async throws -> ProfileResponse {
        let profileResponse: ProfileResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/user",
            method: "GET"
        )
        return profileResponse
    }
}
