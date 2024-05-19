//
//  UIViewController+Extension.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 19.05.2024.
//

import UIKit

extension UIViewController {
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

