//
//  SplashVC.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 23/06/23.
//

import UIKit

class SplashVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Background
        self.view.backgroundColor = .appGreen
        // Title
        self.titleLabel.text = "Frankione"
        self.titleLabel.textColor = .white
        self.titleLabel.font = .systemFont(ofSize: 32, weight: .heavy)
        // LoadScreen
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.loadScreen()
        }
    }
    private func loadScreen() {
        let vc = HomeVC.instantiate()
        UIStoryboard.makeNavigationControllerAsRootVC(vc)
    }

}
