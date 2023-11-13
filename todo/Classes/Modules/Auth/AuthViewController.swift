//
//  ViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 26.10.2023.
//

import UIKit

final class AuthViewController: ParentViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = L10n.Auth.title
        navigationController?.navigationBar.prefersLargeTitles = true

        emailTextField.setup(placeholder: L10n.Auth.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)

        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var signUpButton: UIButton!

    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignIn() {
        var isValidFlag = true

        if !(emailTextField.text?.isEmpty != true) {
            emailTextField.show(error: L10n.Auth.textFieldError)
            isValidFlag = false
        } else if !(ValidationManager.isValid(email: emailTextField.text)) {
            emailTextField.show(error: L10n.Auth.emailTextFieldError)
            isValidFlag = false
        }

        if !(passwordTextField.text?.isEmpty != true) {
            passwordTextField.show(error: L10n.Auth.textFieldError)
            isValidFlag = false
        }

        if isValidFlag {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
            view.window?.rootViewController = vc
        }
    }
}
