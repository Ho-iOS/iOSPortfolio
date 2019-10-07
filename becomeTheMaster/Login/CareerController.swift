//
//  CareerController.swift
//  portfolioTabBar
//
//  Created by Loho on 24/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

let reuseIdentifier = "collectionCell1"

class CareerController: UIViewController, UINavigationControllerDelegate {
    @IBOutlet var mediaCollectionView: UICollectionView!
    @IBOutlet var addMediaButton: UIButton!
    @IBOutlet var aboutTextView: PlaceHolderTextView!
    var collectionItems = [String]()
    private var profileImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initLayout()
        setCollectionItems()
    }
    
    func setCollectionItems() {NSLog("setCollectionItems")
        collectionItems = ["fruit01.png", "fruit02.png", "fruit03.png", "fruit04.png",
                           "fruit05.png", "fruit06.png", "fruit07.png", "fruit08.png",]
    }
    
    @IBAction func addMediaPressed(_ sender: UIButton) {
        handlePlusMedia()
        
    }
    
    @objc private func handlePlusMedia() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)

    }
    
    func initLayout() {
        //Custom TextView
        aboutTextView.layer.cornerRadius = 10
        aboutTextView.layer.borderWidth = 0.3
        aboutTextView.layer.borderColor = UIColor.colorWithRGBHex(hex: 0x00D963).cgColor
        aboutTextView.tintColor = UIColor.black
        aboutTextView.placeholderLabel.text = "Add a caption..."
        aboutTextView.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        aboutTextView.autocorrectionType = .no
        //Custom Button
        addMediaButton.layer.cornerRadius = 5
    }
    

    
}

extension CareerController: UICollectionViewDataSource {
    // MARK: - CollectionView DataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionItems.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell1", for: indexPath) as! MediaCollectionViewCell
        
        cell.imageView.image = UIImage(named: collectionItems[indexPath.row])
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
        
    }
    
}
extension CareerController: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWithd = collectionView.frame.width / 5 - 10
        
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    }
    
    //Top & Bottom Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
    }
    
    //Side Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
    }
}


//MARK: UIImagePickerControllerDelegate
extension CareerController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        print(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImage = editedImage
//            print(profileImage)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage = originalImage
//            print(profileImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
