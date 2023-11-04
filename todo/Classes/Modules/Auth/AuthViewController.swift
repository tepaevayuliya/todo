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
        //emailTextField.placeholder = L10n.Auth.emailTextField
        //passwordTextField.placeholder = L10n.Auth.passwordTextField

        emailTextField.setup(placeholder: L10n.Auth.emailTextField, text: nil)
        passwordTextField.setup(placeholder: L10n.Auth.passwordTextField, text: nil)

        signInButton.setTitle(L10n.Auth.signInButton, for: .normal)
        signUpButton.setTitle(L10n.Auth.signUpButton, for: .normal)

        passwordTextField.enableSecurityMode()


        addTapToHideKeyboardGesture()
        // Do any additional setup after loading the view.
    }

    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    @IBOutlet private var emailTextField: TextInput!
    @IBOutlet private var passwordTextField: TextInput!

    @IBAction private func didTapSignIn() {
        passwordTextField.show(error: "Ошибка!")

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "NavMainVC")
//        view.window?.rootViewController = vc

    }
    


}

