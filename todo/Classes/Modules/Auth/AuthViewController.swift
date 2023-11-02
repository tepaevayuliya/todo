//
//  ViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 26.10.2023.
//

import UIKit

class AuthViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        emailTextField.placeholder = "E-mail"
        passwordTextField.placeholder = "Пароль"

        signInButton.setTitle("Войти", for: .normal)
        signUpButton.setTitle("Еще нет аккаунта?", for: .normal)

        // Do any additional setup after loading the view.
    }


    //@IBAction func Button(_ sender: UIButton) {
    //}
    //@IBOutlet var Button: [UIButton]!
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!



}

