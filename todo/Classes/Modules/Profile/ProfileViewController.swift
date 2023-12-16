//
//  ProfileViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 08.12.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Profile.title

        exitButton.setup(mode: TextButton.Mode.destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2

        getUserInfo()
    }

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var exitButton: TextButton!

    @IBAction private func didTapExitButton() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let attributedStringForMessage = NSAttributedString(string: L10n.Profile.alertTitle, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.Color.secondary.withAlphaComponent(0.8)])
        alertController.setValue(attributedStringForMessage, forKey: "attributedMessage")

        let selectAction = UIAlertAction(title: L10n.Profile.alertButton, style: .destructive) { _ in
            ParentViewController.goToAuth()
        }

        let cancelAction = UIAlertAction(title: L10n.Profile.alertCancel, style: .cancel, handler: nil)

        alertController.addAction(selectAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }

    private var data: ProfileResponse?

    private func getUserInfo() {
        Task {
            do {
                (view as? StatefullView)?.state = .loading

                data = try await NetworkManager.shared.getUserProfile()

                userName.text = data?.name

                getProfileImageView()
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbarVC(message: error.localizedDescription)
                }

            }
        }
    }

    private func getProfileImageView() {
        Task {
            do {
                if let imageId = self.data?.imageId {
                    let modifier = AnyModifier { request in
                        var request = request
                        if let token = UserManager.shared.accessToken {
                            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                        }
                        return request
                    }

                    profileImageView.kf.cancelDownloadTask()
                    let urlString = "http://45.144.64.179/api/user/photo/\(imageId)"
                    profileImageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage.strokedCheckmark, options: [.requestModifier(modifier)])
                }
            } catch {
                DispatchQueue.main.async {
                    self.showSnackbarVC(message: error.localizedDescription)
                }
            }
        }

    }
}
