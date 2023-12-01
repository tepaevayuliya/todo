//
//  NetworkManagers.swift
//  todo
//
//  Created by Юлия Тепаева on 23.11.2023.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    case wrongStatusCode, wrongURL, wrongResponse

    var errorDescription: String? {
        switch self {
        case .wrongStatusCode:
            return L10n.NetworkError.wrongStatusCode
        case .wrongURL:
            return L10n.NetworkError.wrongURL
        case .wrongResponse:
            return L10n.NetworkError.wrongResponse
        }
    }
}

struct SignInRequestBody: Encodable {
    let email: String
    let password: String
}

struct SignUpRequestBody: Encodable {
    let name: String
    let email: String
    let password: String
}

struct TodosRequestBody: Encodable {
    let category: String = ""
    let title: String
    let description: String
    let date: Int
    let coordinate: Coordinate = Coordinate(longitude: "", latitude: "")
}

struct Coordinate: Encodable {
    let longitude: String
    let latitude: String
}

final class NetworkManagers {
    static var shared = NetworkManagers()

    private init() {}

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970

        return decoder
    }()

    struct EmptyEncodable: Encodable {}

    func request<Response: Decodable> (urlPart: String, method: String) async throws -> Response {
        try await request(urlPart: urlPart, method: method, requestBody: Optional<EmptyEncodable>.none)
    }

    func request<Request: Encodable, Response: Decodable> (
        urlPart: String,
        method: String,
        requestBody: Request?
    ) async throws -> Response {
        guard let url = URL(string: "\(PlistFiles.cfApiBaseUrl)/api/\(urlPart)") else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "\(method)"

        if let requestBody {
            request.httpBody = try JSONEncoder().encode(requestBody)
        }

//        request.httpBody = isRequestNil ? nil : try JSONEncoder().encode(requestBody)

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let AuthAccessToken = "Bearer \(responseToken.accessToken)"
        request.setValue("\(AuthAccessToken)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await URLSession.shared.data(for: request)
        if let httpResponse = resp as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200 ..< 400 :
                if data.isEmpty, let emptyData = "{}".data(using: .utf8) {
                    return try decoder.decode(Response.self, from: emptyData)
                }
                return try decoder.decode(DataResponse<Response>.self, from: data).data
            default:
//                let response = String(data: data, encoding: .utf8) ?? ""
                throw NetworkError.wrongStatusCode
            }
        } else {
            throw NetworkError.wrongResponse
        }
    }
}
