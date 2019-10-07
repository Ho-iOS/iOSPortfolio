//
//  SignInViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 17/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class MentorSignUpController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var nickNameTextField: UITextField!
    @IBOutlet var verifyCheckButton: UIButton!
    @IBOutlet var verifyRequestButton: UIButton!
    @IBOutlet var optTextField: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var plusPhotoButton: UIButton!
    
    private var profileImage: UIImage?
    
    var users = [User]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var signupFlag:Bool = false
    var doubleCheckFlag:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        appDelegate.globalFlag = false
    }
    
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //Mark: - Button Action
    @IBAction func verifyCheckButtonPressed(_ sender: UIButton) {

        guard let otpNumber = optTextField.text else {return}
        guard let phoneNumber = phoneNumberTF.text else {return}
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else {return}

        handleSignUp()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpNumber)

        Auth.auth().currentUser?.link(with: credential) { (user,err) in
            if err == nil {

                guard let uid = user?.user.uid else {return}

                Database.database().reference().child("users").child(uid).updateChildValues(["phoneNumber":phoneNumber])
                print("Anonymous account successfully upgraded", user as Any)
//                DispatchQueue.main.async {
//                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
//                }
            } else {
                print("Error upgrading anonymous account", err as Any)
            }
            
        }
    }
    
    @IBAction func verifyRequestButtonPressed(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTF.text else {return}
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, err) in
            if err == nil {
                //Do Something
                print("Succes: \(String(describing: verificationID))")
                guard let verifyID = verificationID else {return}
                UserDefaults.standard.set(verifyID,forKey: "verificationID")
                UserDefaults.standard.synchronize()
            } else {
                print("Unable to Secret Verification Code from Firebase", err?.localizedDescription as Any)
            }
        }
//        handleSignUp()
    }
    
    @IBAction func plusButtonPressed(_ sender: UIButton) {
        handlePlusPhoto()
    }
    
    @IBAction func nickDuplicatedCheck(_ sender: UIButton) {
        nickNameDuplicatedCheckFunc()
    }
    
    func nickNameDuplicatedCheckFunc() {
        Database.database().fetchAllUsers(includeCurrentUser: false, completion: { (users) in
            self.users = users
            
            if users.count == 0 {
                let alertController = UIAlertController(title: "중복확인", message:
                    "사용가능한 별명입니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
                self.doubleCheckFlag = true
            }
            
            for idx in 0 ..< users.count {
                
                if users[idx].nickname == self.nickNameTextField.text {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "중복된 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    self.resetInputFields(flag: true)
                    self.doubleCheckFlag = false
                } else {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "사용가능한 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    self.doubleCheckFlag = true
                }
            }
        }) { (_) in
            print("Fetch Users Err in FollowTableView")
        }
    }
    
    @objc private func handleSignUp() {
        if doubleCheckFlag {
            guard let email = emailTextField.text else { return }
            guard let username = nameTextField.text else { return }
            guard let nickname = nickNameTextField.text else { return }
            guard let password = pwTextField.text else { return }
            guard let passwordCheck = pwCheckTextField.text else { return }
            resetInputFields(flag: false)
            signUpFlag()
            
            if password == passwordCheck && self.signupFlag == true {
                Auth.auth().createMentor(withEmail: email, username: username, nickname: nickname, password: password, profileImage: profileImage) { (err) in
                    if err != nil {
                        self.appDelegate.globalFlag = true
                        return
                    }
                }
            } else {
                let alertController = UIAlertController(title: "회원가입 실패", message:
                    "패스워드가 일치하지 않습니다.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                }))
                self.present(alertController, animated: true, completion: nil)
                self.appDelegate.globalFlag = false
                resetInputFields(flag: true)
            }
        } else {
            let alertController = UIAlertController(title: "회원가입 실패", message:
                "별명을 확인해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.resetInputFields(flag: true)
            return
        }
    }
    
    private func resetInputFields(flag: Bool) {
        emailTextField.isUserInteractionEnabled = flag
        nameTextField.isUserInteractionEnabled = flag
        nickNameTextField.isUserInteractionEnabled = flag
        pwTextField.isUserInteractionEnabled = flag
        pwCheckTextField.isUserInteractionEnabled = flag
    }
    
    func signUpFlag() {
        if nameTextField.text != "" && emailTextField.text != "" && pwTextField.text != "" && pwCheckTextField.text != "" && phoneNumberTF.text != "" && optTextField.text != "" && nickNameTextField.text != "" {
            self.signupFlag = true
            appDelegate.globalFlag = true
        } else {
            let alertController = UIAlertController(title: "회원가입 실패", message:
                "작성하지 않은 항목이 있습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            resetInputFields(flag: true)
            self.signupFlag = false
            appDelegate.globalFlag = false
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
        //Button
        plusPhotoButton.setBorderColor(width: 0.5, color: myColor, corner: 140 / 2)
        //TextField
        pwCheckTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        emailTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        nameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        phoneNumberTF.setBorderColor(width: 0.5, color: myColor, corner: 5)
        optTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        nickNameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
}

//MARK: UIImagePickerControllerDelegate
extension MentorSignUpController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImage = originalImage
        }
        plusPhotoButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        plusPhotoButton.layer.borderWidth = 0.5
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
