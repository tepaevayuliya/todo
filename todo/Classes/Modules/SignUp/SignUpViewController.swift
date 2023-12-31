//
//  SignUpViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 04.11.2023.
//

import UIKit
import Dip

final class SignUpViewController: ParentViewController {
    @Injected private var networkManager: SignUpManager!

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(false)
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
            signUpButton.setLoading(true)
            Task {
                do {
                    _ = try await networkManager.signUp(name: nameTextField.text ?? "", email: emailTextField.text ?? "", password: passwordTextField.text ?? "")

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    view.window?.rootViewController = vc
                } catch {
                    DispatchQueue.main.async {
                        self.snackBarView.showSnackbarVC(message: error.localizedDescription)
                    }
                }
                signUpButton.setLoading(false)
            }
        }
    }
}
