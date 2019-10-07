//
//  LoginViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 17/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: pwTextField.text!) { (user, error) in
            if user != nil{
                print("login success")
                self.presentingViewController?.dismiss(animated: true, completion: nil)
                
            }
            else{
                print("login fail")
            }
        }
        
    }
    
    @IBAction func myExit(_ sender: UIStoryboardSegue) {
        
    }

}
