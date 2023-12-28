//
//  AuthManager.swift
//  todo
//
//  Created by Юлия Тепаева on 14.12.2023.
//

import Foundation

protocol AuthManager {
    func signIn(email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: AuthManager {
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
}
