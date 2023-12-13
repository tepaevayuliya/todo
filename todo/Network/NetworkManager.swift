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
    static var shared = NetworkManager()

    private init() {}

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970

        return decoder
    }()

    private lazy var encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970

        return encoder
    }()

    struct EmptyEncodable: Encodable {}

    func requestWithoutRequestBody<Response: Decodable>(urlPart: String, method: String) async throws -> Response {
        let data = try await request(urlPart: urlPart, method: method, requestBody: EmptyEncodable?.none)
        return try decoder.decode(DataResponse<Response>.self, from: data).data
    }

    func requestWithRequestBody<Request: Encodable, Response: Decodable>(urlPart: String, method: String, requestBody: Request?) async throws -> Response {
        let data = try await request(urlPart: urlPart, method: method, requestBody: requestBody)
        return try decoder.decode(DataResponse<Response>.self, from: data).data
    }

    func requestWithResponseData(urlPart: String, method: String) async throws -> Data {
        try await request(urlPart: urlPart, method: method, requestBody: EmptyEncodable?.none)
    }

    private func request<Request: Encodable>(
        urlPart: String,
        method: String,
        requestBody: Request?
    ) async throws -> Data {
        guard let url = URL(string: "\(PlistFiles.apiBaseUrl)/api/\(urlPart)") else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"

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
                if data.isEmpty, let emptyData = "{\"data\":{}}".data(using: .utf8) {
                    return emptyData
                }
                return data
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
}
