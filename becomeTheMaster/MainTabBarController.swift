//
//  MainTabBarController.swift
//  portfolioTabBar
//
//  Created by Loho on 17/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

//#98B8DB
//#7394B9
//#4F6C9A
//#405888

class MainTabBarController: UITabBarController {
    @IBOutlet var mainTabBar: UITabBar!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.selectedIndex = 0
        if Auth.auth().currentUser == nil {
            presentLoginController()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBar.unselectedItemTintColor = UIColor.colorWithRGBHex(hex: 0x7394B9)
        
        tabBar.isTranslucent = false
        
    }
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            self.present(controller, animated: true, completion: nil)
        }
    }

}
