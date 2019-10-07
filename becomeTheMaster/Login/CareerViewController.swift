//
//  CareerViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 26/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseStorage

class CareerViewController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var licenseCollection: LicenseCollection!
//    @IBOutlet var mediaCollection: MediaCollection!
    @IBOutlet var addLicenseButton: UIButton!
//    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var aboutTextView: PlaceHolderTextView!
    let imagePickerController = UIImagePickerController()
    
    var mediaImageUrls:[String] = []
    var licenseImageUrls:[String] = []
    var clickedButton:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        licenseCollection.licenseSetCollectionItems()
//        mediaCollection.mediaSetCollectionItems()
        initLayout()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if imagePickerController.isBeingPresented == false {
            if let uid = Auth.auth().currentUser?.uid {
                if let about = aboutTextView.text {
                    Database.database().reference().child("users").child(uid).child("about").setValue(about)

//                    if let mediaImageArray:[UIImage] = mediaCollection.mediaImageArray {
//                        mediaImageArray.forEach { (mediaImage) in
//                            Storage.storage().uploadUserMediaImage(mediaImage: mediaImage, completion: { (mediaImageUrl) in
//                                self.mediaImageUrls.append(mediaImageUrl)
//                                Database.database().reference().child("users").child(uid).child("mediaImage").setValue(self.mediaImageUrls)
//                            })
//                        }
                
                    if let licenseImageArray:[UIImage] = licenseCollection.licenseImageArray {
                        licenseImageArray.forEach { (licenseImage) in
                            Storage.storage().uploadUserLicenseImage(licenseImage: licenseImage, completion: { (licenseImageUrl) in
                                self.licenseImageUrls.append(licenseImageUrl)
                                Database.database().reference().child("users").child(uid).child("licenseImage").setValue(self.licenseImageUrls)
                            })
                        }
                    } // if let license
//                    } // if let media
                } // if let about
            } // if let uid
        }
    }
    
//    @IBAction func addMediaPressed(_ sender: UIButton) {
//        handlePlusPhoto()
//        clickedButton = "Media"
//    }
    
    @IBAction func addLicensePressed(_ sender: UIButton) {
        handlePlusPhoto()
//        clickedButton = "License"
//
    }
    
    @objc private func handlePlusPhoto() {
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    //#98B8DB
    //#7394B9
    //#4F6C9A
    //#405888
    //Mark: - Custom Layout
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
        //Custom TextView
        aboutTextView.setBorder(width: 0.5, color: myColor, corner: 5)
        aboutTextView.placeholderLabel.text = "Add a caption..."
        aboutTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        aboutTextView.autocorrectionType = .no
        //Custom Button
//        addMediaButton.applyGradient(colours: [ UIColor.colorWithHexString(hexStr: "#5574F7"), UIColor.colorWithHexString(hexStr: "#60C3FF")])
        addLicenseButton.applyGradient(colours: [ UIColor.colorWithHexString(hexStr: "#405888"), UIColor.colorWithHexString(hexStr: "#98B8DB")])
        //Custom Collection View.
//        mediaCollection.setBorder(width: 0.5, color: myColor, corner: 5)
        licenseCollection.setBorder(width: 0.5, color: myColor, corner: 5)
        

    }

}


//MARK: - UIImagePickerControllerDelegate
extension CareerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            licenseCollection.licenseImageArray.append(editedImage)
//            if clickedButton == "Media" {
//                mediaCollection.mediaImageArray.append(editedImage)
//            } else if clickedButton == "License" {
//                licenseCollection.licenseImageArray.append(editedImage)
//            }
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            licenseCollection.licenseImageArray.append(originalImage)
//            if clickedButton == "Media" {
//                mediaCollection.mediaImageArray.append(originalImage)
//            } else if clickedButton == "License" {
//                licenseCollection.licenseImageArray.append(originalImage)
//            }
        }
        clickedButton = ""
        licenseCollection.reloadData()
//        mediaCollection.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
