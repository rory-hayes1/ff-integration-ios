//
//  HomeVC.swift
//  FrankieoneiOS
//
//  Created by Shivaditya Kr on 23/06/23.
//

import UIKit
protocol HomeView: UIViewController {
    var ffButton: UIButton! {get}
}
class HomeVC: UIViewController, HomeView {
    var uiVC: HomeUIVC?
    @IBOutlet weak var ffButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiVC?.setupUI()
    }
    
    class func instantiate()-> UIViewController {
        let vc = UIStoryboard.home.instanceOf(viewController: HomeVC.self)!
        vc.uiVC = HomeUIVC(view: vc)
        return vc
    }
}
