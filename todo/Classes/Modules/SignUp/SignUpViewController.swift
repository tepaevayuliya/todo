//
//  SignUpViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 04.11.2023.
//

import UIKit

final class SignUpViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.SignUp.title
        navigationController?.navigationBar.prefersLargeTitles = true

        nameTextField.setup(placeholder: L10n.SignUp.nameTextField, text: nil)
        emailTextField.setup(placeholder: L10n.SignUp.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.SignUp.passwordTextField, text: nil)

        signUpButton.setTitle(L10n.SignUp.signUpButton, for: .normal)
        signUpButton.setup(mode: PrimaryButton.Mode.large)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    @IBOutlet private var signUpButton: PrimaryButton!

    @IBOutlet private var nameTextField: TextInput!
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignUp() {
        var isValidFlag = true

        if nameTextField.text?.isEmpty ?? true {
            nameTextField.show(error: L10n.SignUp.textFieldError)
            isValidFlag = false
        } else if !ValidationManager.isValid(commonText: nameTextField.text, symbolsCount: 70) {
            nameTextField.show(error: L10n.SignUp.nameTextFieldError)
            isValidFlag = false
        }

        if emailTextField.text?.isEmpty ?? true {
            emailTextField.show(error: L10n.SignUp.textFieldError)
            isValidFlag = false
        } else if !(ValidationManager.isValid(email: emailTextField.text)) {
            emailTextField.show(error: L10n.SignUp.emailTextFieldError)
            isValidFlag = false
        }

        if passwordTextField.text?.isEmpty ?? true {
            passwordTextField.show(error: L10n.SignUp.textFieldError)
            isValidFlag = false
        } else if !ValidationManager.isValid(commonText: passwordTextField.text, symbolsCount: 256) {
            passwordTextField.show(error: L10n.SignUp.passwordTextFieldError)
            isValidFlag = false
        }

        if isValidFlag {
            Task {
                do {
                    let requestBody = SignUpRequestBody(name: nameTextField.text ?? "", email: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "")
                    var response = AuthResponse()
                    response = try await NetworkManagers.shared.request(urlPart: "auth/registration", method: "POST", requestBody: requestBody)
                    UserManager.shared.set(accessToken: response.accessToken)

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    view.window?.rootViewController = vc
                } catch {
                    DispatchQueue.main.async {
                        self.showAlertVC(massage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
