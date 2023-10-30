//
//  ViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 26.10.2023.
//

import UIKit

class ViewController: UIViewController {


    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Авторизация"
        navigationController?.navigationBar.prefersLargeTitles = true
        emailTextField.placeholder = "E-mail"
        passwordTextField.placeholder = "Пароль"

        enterButton.setTitle("Войти", for: .normal)
        singUpButton.setTitle("Еще нет аккаунта?", for: .normal)

        // Do any additional setup after loading the view.
    }


    @IBAction func Button(_ sender: UIButton) {
    }
    //@IBOutlet var Button: [UIButton]!
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var singUpButton: UIButton!

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!



}

