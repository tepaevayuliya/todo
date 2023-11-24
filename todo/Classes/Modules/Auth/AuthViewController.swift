//
//  ViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 26.10.2023.
//

import UIKit
import Combine

final class AuthViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true

        emailTextField.setup(placeholder: "email", text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)

        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)
        signInButton.setup(mode: PrimaryButton.Mode.large)
        signUpButton.setup(mode: TextButton.Mode.normal)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
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
                    let response = try await NetworkManagers.shared.signIn(email: emailTextField.text ?? "", password: passwordTextField.text ?? "")
                    log.debug("\(response.accessToken)")
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
                    view.window?.rootViewController = vc
                } catch {
                    let alertVC = UIAlertController(title: "Ошибка!", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "Закрыть!", style: .cancel))
                    present(alertVC, animated: true)
                }
            }

//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
//            view.window?.rootViewController = vc
        } else if !(ValidationManager.isValid(email: emailTextField.text)) {
            emailTextField.show(error: "Емейл некоррекный\nПример двустрочной ошибки и текста, который не влезает")
        }


    }
}
