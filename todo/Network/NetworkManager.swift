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
            return "Упс1! Что-то пошло не так"
        case .wrongURL:
            return "Упс2! Что-то пошло не так"
        case .wrongResponse:
            return "Упс3! Что-то пошло не так"
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

struct TodosResponseBody: Encodable {
    let category: String
    let title: String
    let description: String
    let date: Int
    let coordinate: Coordinate
}

struct Coordinate: Encodable {
    let longitude: String
    let latitude: String
}

struct GetAllTasks: Encodable {}

let bodyRequest = EmptyResponse()

final class NetworkManagers {
    static var shared = NetworkManagers()

    private init() {}

    private lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .secondsSince1970

        return decoder
    }()

//    struct EmptyEncodable: Encodable {}
//
//    func request<Response: Decodable> (url: String, metod: String) async throws -> Response {
//        try await request(urlPart: url, metod: metod, requestBody: Optional<EmptyEncodable>.none)
//    }

    func request<Request: Encodable, Response: Decodable> (
        urlPart: String,
        metod: String,
        requestBody: Request,
        response: Response,
        isRequestNil: Bool
    ) async throws -> Response {
        guard let url = URL(string: "\(PlistFiles.cfApiBaseUrl)/api/\(urlPart)") else {
            throw NetworkError.wrongURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "\(metod)"

//        if let _ = requestBody {
//            request.httpBody = try JSONEncoder().encode(requestBody)
//        }

        if isRequestNil {
            request.httpBody = nil
        } else {
            request.httpBody = try JSONEncoder().encode(requestBody)
        }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let AuthAccessToken = "Bearer \(responseToken.accessToken)"
        request.setValue("\(AuthAccessToken)", forHTTPHeaderField: "Authorization")

        let (data, resp) = try await URLSession.shared.data(for: request)
        if let httpResponse = resp as? HTTPURLResponse {
            switch httpResponse.statusCode {
            case 200 ..< 400 :
                if data.isEmpty {
                    return bodyRequest as! Response
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
