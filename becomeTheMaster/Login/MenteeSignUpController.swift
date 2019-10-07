//
//  MenteeSignUpController.swift
//  portfolioTabBar
//
//  Created by Loho on 20/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class MenteeSignUpController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var plusPhotoButton: UIButton!
    @IBOutlet var nicknameTextField: UITextField!
    @IBOutlet var plusProfileButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var verifyButton: UIButton!
    @IBOutlet var otpTextField: UITextField!
    @IBOutlet var phoneNumberTF: UITextField!
    @IBOutlet var pwCheckTextField: UITextField!
    @IBOutlet var pwTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    
    var signupFlag:Bool = false
    var doubleCheckFlag:Bool = false
    var users = [User]()
    private var profileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        hideKeyboardWhenTappedArroun()

        initLayout()
        
    }
    
    
    func fetchAllUsers() {
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
                if users[idx].nickname == self.nicknameTextField.text {
                    let alertController = UIAlertController(title: "중복확인", message:
                        "중복된 별명입니다.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                    }))
                    self.present(alertController, animated: true, completion: nil)
                    self.resetInputFields()
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
    @IBAction func duplicateCheckButton(_ sender: UIButton) {
        if self.nicknameTextField.text == "" {
            let alertController = UIAlertController(title: "중복확인", message:
                "별명을 입력해 주세요.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.doubleCheckFlag = false
        }
        fetchAllUsers()
    }
    
    @IBAction func plusPhotoButtonPressed(_ sender: UIButton) {
        handlePlusPhoto()
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func phoneButtonPressed(_ sender: UIButton) {

        guard let phoneNumber = phoneNumberTF.text else {return}
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, err) in
            if err == nil {
                print("Succes: \(String(describing: verificationID))")
                guard let verifyID = verificationID else {return}
                UserDefaults.standard.set(verifyID,forKey: "verificationID")
                UserDefaults.standard.synchronize()
            } else {
                print("Unable to Secret Verification Code from Firebase", err?.localizedDescription as Any)
            }
        }
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        guard let otpNumber = otpTextField.text else {return}
        guard let phoneNumber = phoneNumberTF.text else {return}
        guard let verificationID = UserDefaults.standard.string(forKey: "verificationID") else {return}
        
        handleSignUp()
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: otpNumber)
        
        Auth.auth().currentUser?.link(with: credential) { (user,err) in
            if err == nil {
                guard let uid = user?.user.uid else {return}
                Database.database().reference().child("users").child(uid).updateChildValues(["phoneNumber":phoneNumber])
                print("Anonymous account successfully upgraded", user as Any)
                DispatchQueue.main.async {
                    self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                }
            } else {
                print("Error upgrading anonymous account", err as Any)
            }
            
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
        plusPhotoButton.setBorderColor(width: 0.5, color: myColor, corner: 140 / 2)
        pwCheckTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        emailTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        nameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        phoneNumberTF.setBorderColor(width: 0.5, color: myColor, corner: 5)
        otpTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        nicknameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
    @objc private func handleSignUp() {
        guard let email = emailTextField.text else { return }
        guard let username = nameTextField.text else { return }
        guard let password = pwTextField.text else { return }
        guard let passwordCheck = pwCheckTextField.text else { return }
        emailTextField.isUserInteractionEnabled = false
        nameTextField.isUserInteractionEnabled = false
        pwTextField.isUserInteractionEnabled = false
        pwCheckTextField.isUserInteractionEnabled = false
        
        if password == passwordCheck {

        } else {
            let alertController = UIAlertController(title: "회원가입 실패", message:
                "패스워드가 일치하지 않습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            resetInputFields()
        }

    }
    
    private func resetInputFields() {
        emailTextField.text = ""
        nameTextField.text = ""
        pwTextField.text = ""
        pwCheckTextField.text = ""
        
        emailTextField.isUserInteractionEnabled = true
        nameTextField.isUserInteractionEnabled = true
        pwTextField.isUserInteractionEnabled = true
        pwCheckTextField.isUserInteractionEnabled = true

    }
    
}

//MARK: - UITextFieldDelegate

extension MenteeSignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


//MARK: UIImagePickerControllerDelegate
extension MenteeSignUpController: UIImagePickerControllerDelegate {
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

