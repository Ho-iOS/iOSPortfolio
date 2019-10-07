//
//  MyPageViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 17/09/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class MyPageViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var plusPhotoButton: UIButton!
    @IBOutlet var profileImageView: CustomImageView!
    @IBOutlet var whoLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var timeView: UIView!
    @IBOutlet var fieldView: UIView!
    @IBOutlet var locationView: UIView!
    @IBOutlet var nicknameView: UIView!
    @IBOutlet var timeTextView: UITextView!
    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var phoneNumberLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    var user: User?
    var profileImage: UIImage?
    
    let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().fetchUser(withUID: uid!, completion: {(user) in
            self.user = user
            self.profileImageView.loadImage(urlString: user.profileImageUrl!)
            self.whoLabel.text = user.who
            self.nameLabel.text = user.username
            self.emailLabel.text = Auth.auth().currentUser?.email
            self.phoneNumberLabel.text = user.phoneNumber
            self.nicknameLabel.text = user.nickname
            self.locationLabel.text = user.location
            self.fieldLabel.text = user.field
            if let timeArr = user.dayTime {
                var timeStr = ""
                for idx in 0 ..< timeArr.count {
                    if idx == 0 {
                        timeStr += "\(timeArr[idx])"
                    } else {
                        timeStr += "\n\(timeArr[idx])"
                    }
                }
                self.timeTextView.text = timeStr
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponent()
        
        //SetLocation
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(popUpLocationView(_:)))
        locationView.addGestureRecognizer(locationGesture)
        //SetField
        let fieldGesture = UITapGestureRecognizer(target: self, action: #selector(popUpFieldView(_:)))
        fieldView.addGestureRecognizer(fieldGesture)
        //SetTime
        let timeGesture = UITapGestureRecognizer(target: self, action: #selector(popUpTimeView(_:)))
        timeView.addGestureRecognizer(timeGesture)
        
        let nicknameGesture = UITapGestureRecognizer(target: self, action: #selector(popUpNicknameView(_:)))
        nicknameView.addGestureRecognizer(nicknameGesture)
    }
    
    func initComponent() {
        self.profileImageView.layer.cornerRadius = 5
//        self.timeTextView.isUserInteractionEnabled = false
        self.timeTextView.isEditable = false
    }
    
    @objc func popUpNicknameView(_ sender: UIGestureRecognizer) {
        print("@@@@@@@@")
        let myPageStoryBoard = UIStoryboard(name: "Setting", bundle: nil)
        let nicknameVC = myPageStoryBoard.instantiateViewController(withIdentifier: "nicknameVC") as! NicknameChangeController
//        nicknameVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))
        navigationController?.pushViewController(nicknameVC, animated: true)
    }
    
    @objc func popUpLocationView(_ sender: UIGestureRecognizer) {
        let locationVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorSecond") as! CityController
        locationVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))

        navigationController?.pushViewController(locationVC, animated: true)
    }

    @objc func popUpFieldView(_ sender: UIGestureRecognizer) {
        let fieldVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorThird") as! FieldController
        fieldVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))

        navigationController?.pushViewController(fieldVC, animated: true)
    }
    
    @objc func popUpTimeView(_ sender: UIGestureRecognizer) {
        let timeVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorFourth") as! DayTimeController
        timeVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))
        
        navigationController?.pushViewController(timeVC, animated: true)
    }
    
    @objc func saveValue(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LogoutButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Logout", message: "로그아웃 하시겠습니까??", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            do {
                try Auth.auth().signOut()
                if Auth.auth().currentUser == nil {
                    presentLoginController()
                }
            } catch let err {
                print("Failed to sign out:", err)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {action in

        }))
    }

    private func presentLoginController() {
        DispatchQueue.main.async { // wait until MainTabBarController is inside UI
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
            var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func ProfileImageChanged(_ sender: UIButton) {
        handlePlusPhoto()
    }
    
    @objc private func handlePlusPhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }

    
}

//MARK: UIImagePickerControllerDelegate
extension MyPageViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
//            profileImageView.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImageView.image = editedImage.withRenderingMode(.alwaysOriginal)
            profileImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
//            profileImageView.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
            profileImageView.image = originalImage.withRenderingMode(.alwaysOriginal)
            profileImage = originalImage
        }
//        plusPhotoButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
//        plusPhotoButton.layer.borderWidth = 0.5
        
        //Storage에서 기존 이미지 파일 삭제
        let url = user?.profileImageUrl
        let uid = Auth.auth().currentUser?.uid
        let storageRef = Storage.storage().reference(forURL: url!)
        storageRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("Upload Success")
            }
        }
        
        //Storage와 Database에 새로운 이미지 넣기
        if let profileImages: UIImage = profileImage {
            Storage.storage().uploadUserProfileImage(profileImage: profileImages, completion: { (profileImageUrl) in
                Database.database().reference().child("users").child(uid!).updateChildValues(["profileImageUrl": profileImageUrl])
                print("URL : \(profileImageUrl) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                self.profileImageView.loadImage(urlString: profileImageUrl)
            })
        }
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
