//
//  ProfileViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 08.12.2023.
//

import UIKit
import Kingfisher
import Dip

final class ProfileViewController: ParentViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Injected private var networkManager: ProfileManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = L10n.Profile.title

        exitButton.setup(mode: TextButton.Mode.destructive)
        exitButton.setTitle(L10n.Profile.exitButton, for: .normal)

        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        profileImageView.addGestureRecognizer(tap)
        profileImageView.isUserInteractionEnabled = true

        getUserInfo()

        profileImageView.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
        ])
    }

    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var userName: UILabel!
    @IBOutlet private var exitButton: TextButton!
    private var imagePicker = UIImagePickerController()

    private lazy var loadingIndicator: LoadingIndicatorImageView = {
        let loadingIndicator = LoadingIndicatorImageView()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.image = UIImage.Common.loaderLarge
        loadingIndicator.isHidden = true
        return loadingIndicator
    }()

    @objc
    func handleTap(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false

            present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            showLoadingIndicator(true)
            Task {
                do {
                    _ = try await networkManager.uploadUserPhoto(image: image)
                    profileImageView.image = image
                } catch {
                    DispatchQueue.main.async {
                        self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                    }
                }
                showLoadingIndicator(false)
            }
        }
    }

    private func showLoadingIndicator(_ show: Bool) {
        loadingIndicator.isHidden = !show
        profileImageView.alpha = show ? 0.5 : 1
    }

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

                data = try await networkManager.getUserProfile()

                userName.text = data?.name

                getProfileImageView()
            } catch {
                DispatchQueue.main.async {
                    self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                }
            }
        }
    }

    private func getProfileImageView() {
        guard let imageId = self.data?.imageId else {
            profileImageView.image = UIImage.Profile.user
            return
        }

        let modifier = AnyModifier { request in
            var request = request
            if let token = UserManager.shared.accessToken {
                request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            }
            return request
        }

        profileImageView.kf.cancelDownloadTask()
        let urlString = "\(PlistFiles.apiBaseUrl)/api/user/photo/\(imageId)"
        profileImageView.kf.setImage(with: URL(string: urlString), placeholder: UIImage.Profile.user, options: [.requestModifier(modifier)])
    }

}
