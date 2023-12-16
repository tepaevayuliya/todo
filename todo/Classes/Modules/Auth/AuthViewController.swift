//
//  AuthViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 26.10.2023.
//

import Combine
import UIKit
import Dip

final class AuthViewController: ParentViewController {
    @Injected private var networkManager: AuthManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true

        emailTextField.setup(placeholder: L10n.Auth.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)

        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)
        signInButton.setup(mode: PrimaryButton.Mode.large)
        signUpButton.setup(mode: TextButton.Mode.normal)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
    }

    @IBOutlet private var signInButton: PrimaryButton!
    @IBOutlet private var signUpButton: TextButton!

    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignIn() {
        var isValidFlag = true

        if emailTextField.text?.isEmpty ?? true {
            emailTextField.show(error: L10n.Auth.textFieldError)
            isValidFlag = false
        } else if !(ValidationManager.isValid(email: emailTextField.text)) {
            emailTextField.show(error: L10n.Auth.emailTextFieldError)
            isValidFlag = false
        }

        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.show(error: L10n.Auth.textFieldError)
            isValidFlag = false
        }

        if isValidFlag {
            Task {
                do {
//                    _ = try await NetworkManager.shared.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                    _ = try await networkManager.signInDip(email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    view.window?.rootViewController = vc
                } catch {
                    DispatchQueue.main.async {
                        self.showSnackbarVC(message: error.localizedDescription)
                    }
                }
            }
        }
    }
}
