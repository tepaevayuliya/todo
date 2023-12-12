//
//  ProfileViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 08.12.2023.
//

import UIKit

final class ProfileViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonDisplayMode = .minimal
        navigationItem.title = L10n.Profile.title

        exitButton.setup(mode: TextButton.Mode.destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)

        profileImageView.layer.cornerRadius = 139/2

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
                UserManager.shared.set(accessToken: nil)

                let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                self.view.window?.rootViewController = storyboard.instantiateInitialViewController()
            }

            let cancelAction = UIAlertAction(title: L10n.Profile.alertCancel, style: .cancel, handler: nil)

            alertController.addAction(selectAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        }

    private var data: ProfileResponseBody?

    private func getUserInfo() {
        Task {
            do {
                (view as? StatefullView)?.state = .loading

                data = try await NetworkManagers.shared.requestWithoutRequestBody(urlPart: "user", method: "GET")

                userName.text = data?.name

                getprofileImageView()
            } catch let error as NetworkError {
                if error == .expiredToken {
                    goToAuth()
                } else {
                    DispatchQueue.main.async {
                        self.showSnackbarVC(massage: error.localizedDescription)
                    }
                }
            }
        }
    }

    private func getprofileImageView() {
        Task {
            do {
                (view as? StatefullView)?.state = .loading

                if let imageId = self.data?.imageId {
                    let imgURL: Data = try await NetworkManagers.shared.requestWithResponseData(urlPart: "user/photo/\(imageId)", method: "GET")

                    profileImageView.image = UIImage(data: imgURL)
                }
            } catch let error as NetworkError {
                if error == .expiredToken {
                    goToAuth()
                } else {
                    DispatchQueue.main.async {
                        self.showSnackbarVC(massage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
