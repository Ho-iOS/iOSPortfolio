//
//  NicknameChangeController.swift
//  portfolioTabBar
//
//  Created by Loho on 17/09/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class NicknameChangeController: UIViewController {
    @IBOutlet var applyButton: UIButton!
    @IBOutlet var duplicatedCheckButton: UIButton!
    @IBOutlet var nicknameTextField: UITextField!
    
    var user: User?
    var duplicateCheckFlag = false
    
    private var uid: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.nicknameTextField.isUserInteractionEnabled = true
        uid = Auth.auth().currentUser!.uid
        Database.database().fetchUser(withUID: uid!, completion: {(user) in
            self.user = user
            if let nickname = user.nickname {
                self.nicknameTextField.placeholder = nickname
            } else {
                self.nicknameTextField.placeholder = "Please, put your nickname exactly. "
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = applyNavGradient(colours: [ UIColor.colorWithHexString(hexStr: "#405888"), UIColor.colorWithHexString(hexStr: "#98B8DB")]) {
//            header.contentView.backgroundColor = UIColor(patternImage: img)
            applyButton.backgroundColor = UIColor(patternImage: img)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func duplicatedButtonPressed(_ sender: UIButton) {
        if self.nicknameTextField.text == "" {
            let alertController = UIAlertController(title: "입력 확인", message:
                "공백은 불가능합니다..", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                self.duplicateCheckFlag = false
            }))
            self.present(alertController, animated: true, completion: nil)
            return
        }
        uid = Auth.auth().currentUser!.uid
        Database.database().fetchAllUsers(includeCurrentUser: false, completion: {(users) in
            users.forEach({(user) in
                if user.nickname == self.nicknameTextField.text {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "중복된 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                        self.nicknameTextField.text = ""
                        self.nicknameTextField.placeholder = user.nickname
                        self.duplicateCheckFlag = false
                    }))
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "사용 가능한 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                        self.duplicateCheckFlag = true
//                        self.nicknameTextField.isUserInteractionEnabled = false
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
        }, withCancel: nil)
    }
    
    @IBAction func nicknameChangeApply(_ sender: UIButton) {
        uid = Auth.auth().currentUser!.uid
        if self.duplicateCheckFlag {
            if let nickname = self.nicknameTextField.text {
                Database.database().reference().child("users").child(self.uid!).updateChildValues(["nickname":nickname])
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
}
