//
//  SignUpManager.swift
//  todo
//
//  Created by Юлия Тепаева on 24.12.2023.
//

import Foundation

protocol SignUpManager {
    func signUp(name: String, email: String, password: String) async throws -> AuthResponse
}

extension NetworkManager: SignUpManager {
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
}
