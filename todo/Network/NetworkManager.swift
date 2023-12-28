//
//  NetworkManager.swift
//  todo
//
//  Created by Юлия Тепаева on 23.11.2023.
//

import Combine
import Foundation
import UIKit

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

        if let userImage = requestBody as? Data {
            let boundary = UUID().uuidString

            request.httpBody = multipartFormDataBody(userImage: userImage, boundary: boundary)

            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        } else {
            if let requestBody {
                request.httpBody = try encoder.encode(requestBody)
            }
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }

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

    private func multipartFormDataBody(userImage: Data, boundary: String) -> Data {
        var body = Data()
        body.append("\r\n--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"uploadedFile\"; filename=\"image.jpg\"\r\n")
        body.append("Content-Type: image/jpeg\r\n\r\n")
        body.append(userImage)
        body.append("\r\n--\(boundary)--\r\n")
        return body
    }
}
