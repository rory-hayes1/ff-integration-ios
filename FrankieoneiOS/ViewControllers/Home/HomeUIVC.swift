//
//  HomeUIVC.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 23/06/23.
//

import Foundation

class HomeUIVC {
    var view: HomeView
    init(view: HomeView) {
        self.view = view
    }
    func setupUI() {
        // Navigation
        self.view.title = HomeConst.title
        self.view.navigationController?.navigationBar.prefersLargeTitles = true
        // Button
        self.view.ffButton.setTitle(HomeConst.buttonTitle, for: .normal)
        self.view.ffButton.titleLabel?.font = .systemFont(ofSize: 28, weight: .bold)
        self.view.ffButton.tintColor = .white
        self.view.ffButton.backgroundColor = .appGreen
        self.view.ffButton.layer.cornerRadius = 30
        self.view.ffButton.addTarget(self, action: #selector(didTapFFButton), for: .touchUpInside)
    }
    @objc private func didTapFFButton() {
        let vc = FrankieOneViewController.instantiate()
        vc.modalPresentationStyle = .currentContext
        self.view.navigationController?.pushViewController(vc, animated: true)
//        self.view.navigationController?.pushViewController(ViewController(), animated: true)
    }
}
struct HomeConst {
    static let title = "Frankione Home"
    static let buttonTitle = "FF"
}
