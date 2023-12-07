//
//  UIViewController+Keyboard.swift
//  todo
//
//  Created by Юлия Тепаева on 07.12.2023.
//

import Foundation

import UIKit

private let kHideKeyboardDelegate = HideKeyboardDelegate()

// MARK: - HideKeyboardDelegate

private class HideKeyboardDelegate: NSObject, UIGestureRecognizerDelegate {
    func gestureRecognizer(_: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let view = touch.view, view is UIButton else {
            return true
        }
        return false
    }
}

extension UIViewController {
    func addTapToHideKeyboardGesture(targetView: UIView? = nil) {
        let tapGesture = UITapGestureRecognizer(target: targetView ?? view, action: #selector((targetView ?? view).endEditing))
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = kHideKeyboardDelegate
        view.addGestureRecognizer(tapGesture)
    }
}
