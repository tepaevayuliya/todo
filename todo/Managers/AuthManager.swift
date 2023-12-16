//
//  AuthManager.swift
//  todo
//
//  Created by Юлия Тепаева on 14.12.2023.
//

import Foundation

protocol AuthManager {
    func signInDip(email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: AuthManager {
    func signInDip(email _: String, password _: String) async throws -> AuthResponse {
        let result: AuthResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/auth/login",
            method: "POST",
            requestBody: SignInRequestBody(email: "aa@aa.aa", password: "12345678")
        )
        UserManager.shared.set(accessToken: result.accessToken)
        return result
    }
}
