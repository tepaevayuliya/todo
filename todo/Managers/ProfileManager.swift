//
//  ProfileManager.swift
//  todo
//
//  Created by Юлия Тепаева on 25.12.2023.
//

import Foundation
import UIKit

protocol ProfileManager {
    func getUserProfile() async throws -> ProfileResponse
    func uploadUserPhoto(image: UIImage) async throws -> EmptyResponse
}

extension NetworkManager: ProfileManager {
    func getUserProfile() async throws -> ProfileResponse {
        let profileResponse: ProfileResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/user",
            method: "GET"
        )
        return profileResponse
    }

    func uploadUserPhoto(image: UIImage) async throws -> EmptyResponse {
        let resizedImage = resizeImageTo400x400(image: image)
        let userImage = resizedImage.jpegData(compressionQuality: 0.9)

        let response: EmptyResponse = try await request(
            urlPart: "\(PlistFiles.apiBaseUrl)/api/user/photo",
            method: "POST",
            requestBody: userImage
        )
        return response
    }

    private func resizeImageTo400x400(image: UIImage) -> UIImage {
        let targetSize = CGSize(width: 400, height: 400)

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resizedImage
    }
}
