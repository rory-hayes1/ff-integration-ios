//
//  AppDelegate.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 23/06/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    class func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

