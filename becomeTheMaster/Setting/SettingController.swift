//
//  SettingController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 08/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase
//import GoogleSignIn

class SettingController: UIViewController {
//class SettingController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet var profileImageView : CustomImageView!
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var nicknameLabel : UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var transformBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    var ref:DatabaseReference!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        userInfo()
        mentorMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userInfo()
        mentorMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userInfo()
        mentorMenu()
    }
    
    @IBAction func transformButtonPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                
                presentLoginController()
            }
        } catch let err {
            print("Failed to sign out:", err)
        }
//        GIDSignIn.sharedInstance().signOut()
    }
    
    @IBAction func ProfileEditButtonPressed(_ sender: UIButton) {
        
    }
    
    
    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
            print("@@@@@@@@@@@@@@@@@")
            print(navigationArray)
            print("@@@@@@@@@@@@@@@@@")
//            navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
//            self.navigationController?.viewControllers = navigationArray!

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func userInfo() {
        if Auth.auth().currentUser != nil {
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid ?? "None"
            Database.database().fetchUser(withUID: uid, completion: {(user) in
                self.user = user
                self.profileImageView.loadImage(urlString: (self.user?.profileImageUrl)!)
                self.nameLabel.text = user.username
                self.nicknameLabel.text = user.nickname
            })
        }
    }
    
    func mentorMenu() {
        let uid = Auth.auth().currentUser?.uid ?? "None"
        Database.database().fetchUser(withUID: uid, completion: {(user) in
            self.user = user
//            if user.who == "Mentor User" {
//                self.postImageView.isHidden = false
//                self.postButton.isHidden = false
//                self.transformBarButtonItem.isEnabled = false
//                self.transformBarButtonItem.tintColor = UIColor.clear
//            } else {
//                self.postImageView.isHidden = true
//                self.postButton.isHidden = true
//                self.transformBarButtonItem.isEnabled = true
//            }
        })
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x58C1F9)
        //ImageView
//        profileImageView.setBorderColor(width: 0.5, color: myColor, corner: 84 / 2)
        profileImageView.layer.cornerRadius = 5
    }
    
}
