//
//  SplashScreen.swift
//  todo
//
//  Created by Юлия Тепаева on 28.11.2023.
//

import UIKit

final class SplashViewController: ParentViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let storyboard = UIStoryboard(name: UserManager.shared.accessToken == nil ? "Auth" : "Main", bundle: nil)
        view.window?.rootViewController = storyboard.instantiateInitialViewController()
    }
}
