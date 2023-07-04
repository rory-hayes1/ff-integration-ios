//
//  AppToast.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 23/06/23.
//

import UIKit

class Toast {
    class private func showAlert(backgroundColor:UIColor, textColor:UIColor, message:String) {
        DispatchQueue.main.async {
            let window = (UIApplication.shared.delegate as! AppDelegate).window!
            let button = UIButton(frame: CGRect(x: 32, y: window.frame.height - window.safeAreaInsets.bottom, width: window.frame.size.width - 64, height: 55))
            button.backgroundColor = backgroundColor
            button.setTitle(message, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.titleLabel?.textColor = textColor
            button.titleLabel?.textAlignment = .left
            button.titleLabel?.numberOfLines = 4
            button.alpha = 1
            button.isEnabled = false
            button.isUserInteractionEnabled = false
            // Hiding Toast from app
            button.isHidden = false
            button.layer.cornerRadius = 10
            button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 25, bottom: 5, right: 10)
            button.titleLabel?.adjustsFontForContentSizeCategory = true
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.contentHorizontalAlignment = .center
            button.contentVerticalAlignment = .center
            if (button.titleLabel?.frame.size.height ?? 0 + 20) > 55 {
                button.frame.size.height = ((button.titleLabel?.frame.size.height ?? 0) - 5)
            }
            let onCompletion = {
                Timer.scheduledTimer(withTimeInterval: 1.7, repeats: false) { _ in
                    button.removeFromSuperview()
                }
            }
            window.addSubview(button)
            UIView.animate(withDuration: 0.7, animations: {
                    button.transform = button.transform
                        .translatedBy(x: 0, y: window.safeAreaInsets.bottom - 70)

            }, completion: { _ in
                _ = onCompletion()
            })
        }
    }

    class func showToastMessage(message:String) {
        DispatchQueue.main.async {
            showAlert(backgroundColor: .systemBlue, textColor: .white, message: message)
        }
    }
    class func showErrorMessage(_ message: String) {
        DispatchQueue.main.async {
            showAlert(backgroundColor: .systemRed, textColor: .white, message: message)
        }
    }
}
