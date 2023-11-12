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

        passwordTextField.enableSecurityModeLightweight()

        addTapToHideKeyboardGesture()
    }


    @IBOutlet var signUpButton: UIButton!

    @IBOutlet private var nameTextField: TextInput!
    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignUp() {
        if (nameTextField.isEmpty()) {
            nameTextField.show(error: L10n.SignUp.nameTextFieldError)
        }
    }
}
