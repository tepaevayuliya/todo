//
//  ParenyViewController.swift
//  todo
//
//  Created by Юлия Тепаева on 02.11.2023.
//

import UIKit

class ParentViewController: UIViewController {
    deinit{
        print("\(String(describing: type(of: self))) released")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonDisplayMode = .minimal
    }
}
