//
//  ManagersAssembly.swift
//  toodo
//
//  Created by Юлия Тепаева on 14.12.2023.
//
import Dip
import Foundation

enum ManagersAssembly {
    // swiftlint:disable:next closure_body_length
    static let container: DependencyContainer = {
        let container = DependencyContainer()

        container.register {
            UserDefaults.standard
        }

        container.register { _ -> JSONDecoder in
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .secondsSince1970
            return jsonDecoder
        }

        container.register { _ -> JSONEncoder in
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .secondsSince1970
            return encoder
        }

        container.register {
            NetworkManager(decoder: $0, encoder: $1) as AuthManager
        }

        return container
    }()
}
