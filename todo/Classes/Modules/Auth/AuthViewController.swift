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
        navigationItem.backButtonDisplayMode = .minimal

        //emailTextField.show1(titleText: "Юл1")
//        emailTextField.setup(placeholder: L10n.Auth.emailTextField, text: nil, titleText: "HELP")
        emailTextField.setup(text: nil, titleText: "Пример лейбла над полем ввода")
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)

        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)

        passwordTextField.enableSecurityMode()

        addTapToHideKeyboardGesture()
    }

    @IBOutlet private var signInButton: UIButton!
    @IBOutlet private var signUpButton: UIButton!

    @IBOutlet private var emailTextField: TextViewInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignIn() {
        if (ValidationManager.isValid(email: emailTextField.text) && passwordTextField.text?.isEmpty != true){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
            view.window?.rootViewController = vc
        } else if !(ValidationManager.isValid(email: emailTextField.text)) {
            emailTextField.show(error: "Емейл некоррекный\nПример двустрочной ошибки и текста, который не влезает")
        }
        passwordTextField.show(error: L10n.Auth.passwordTextFieldError)
    }
}
