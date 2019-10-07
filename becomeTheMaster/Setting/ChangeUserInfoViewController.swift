//
//  ChangeUserInfoViewController.swift
//  portfolioTabBar
//
//  Created by 임국성 on 28/08/2019.
//  Copyright © 2019 gs. All rights reserved.
//

import UIKit
import Firebase

class ChangeUserInfoViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var valueTextView: [UITextView]!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var currentPwTextField: UITextField!
    @IBOutlet weak var newPwTextField: UITextField!
    @IBOutlet weak var pwCheckTextField: UITextField!
    @IBOutlet weak var plusPhotoButton: UIButton!
    
    var users = [User]() //allUser
    var user: User? //User
    var doubleCheckFlag:Bool = false
    var pwFlag:Bool = false
    private var profileImage: UIImage?
    var ref:DatabaseReference!
    var profileImageUrls: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        userInfo()
    }
    
    @IBAction func plusPhotoButtonPressed(_ sender: UIButton) {
        handlePlusPhoto()
    }
    
    @IBAction func doubleCheckedButtonPressed(_ sender: UIButton) {
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
    
    @IBAction func passwordCheckButtonPressed(_ sender: UIButton) {
        passwordCheck()
    }
    
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        let nickname = nicknameTextField.text
        let pw = newPwTextField.text
        let pwCheck = pwCheckTextField.text
        let uid = user?.uid
        
        //Storage에서 기존 이미지 파일 삭제
        let url = user?.profileImageUrl
        let storageRef = Storage.storage().reference(forURL: url!)
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("delete success??????????????????????")
            }
        }
        
        //Storage와 Database에 새로운 이미지 넣기
        if let profileImages: UIImage = profileImage {
            Storage.storage().uploadUserProfileImage(profileImage: profileImages, completion: { (profileImageUrl) in
              Database.database().reference().child("users").child(uid!).updateChildValues(["profileImageUrl": profileImageUrl])
                print("URL : \(profileImageUrl) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            })
        }

        if doubleCheckFlag && pw == pwCheck && pwFlag {
            ref.child("users").child(uid!).updateChildValues(["nickname": nickname!])
            changePassword()
            self.navigationController?.popViewController(animated: true)
        } else {
            let alertController = UIAlertController(title: "정보변경 실패", message:
                "입력하지 않은 항목이 있습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.doubleCheckFlag = false
            self.pwFlag = false
            self.resetInputFields()
            return
        }
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x58C1F9)
        //Button
        plusPhotoButton.setBorderColor(width: 0.5, color: myColor, corner: 140 / 2)
        //textView
        for i in 0..<3 {
//            valueTextView[i].setBorderColor(width: 0.5, color: myColor)
            valueTextView[i].isEditable = false
        }
        //textField
        nicknameTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        currentPwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        newPwTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
        pwCheckTextField.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    private func resetInputFields() {
        nicknameTextField.isUserInteractionEnabled = true
        currentPwTextField.isUserInteractionEnabled = true
        newPwTextField.isUserInteractionEnabled = true
        pwCheckTextField.isUserInteractionEnabled = true
    }
    
    func passwordCheck() {
        let pw = newPwTextField.text
        let pwCheck = pwCheckTextField.text
        if currentPwTextField.text == newPwTextField.text && currentPwTextField.text == pwCheckTextField.text {
            let alertController = UIAlertController(title: "비밀번호 확인", message:
                "현재 비밀번호와 새로운 비밀번호가 같습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.pwFlag = false
        } else if currentPwTextField.text == nil {
            let alertController = UIAlertController(title: "비밀번호 확인", message:
                "현재 비밀번호 입력을 부탁드립니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.pwFlag = false
        } else if pw != pwCheck {
            let alertController = UIAlertController(title: "비밀번호 확인", message:
                "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.pwFlag = false
        } else {
            let alertController = UIAlertController(title: "비밀번호 확인", message:
                "사용가능한 비밀번호 입니다.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
            self.pwFlag = true
        }
    }
    
    func changePassword() {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: currentPwTextField.text!)
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if error != nil {
                //..read error message
                print("Error : \(error!)")
            } else {
                //.. go on
                let newPW = self.newPwTextField.text
                Auth.auth().currentUser?.updatePassword(to: newPW!) { (err) in
                    if err != nil {
                        print("Password Change Error : \(err!.localizedDescription)")
                    } else {
                        print("Password Change Success!!!")
                    }
                }
            }
        })
    }
    
    func userInfo() {
        if Auth.auth().currentUser != nil {
            ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid ?? "None"
            Database.database().fetchUser(withUID: uid, completion: {(user) in
                self.user = user
                let url = URL(string: (user.profileImageUrl)!)
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    self.plusPhotoButton.setImage(image, for: .normal)
                }catch let err {
                    print("Error : \(err.localizedDescription)")
                }
                self.nicknameTextField.placeholder = user.nickname
            })
        }
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
}

//MARK: - UITextFieldDelegates
extension ChangeUserInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: UIImagePickerControllerDelegate
extension ChangeUserInfoViewController: UIImagePickerControllerDelegate {
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
