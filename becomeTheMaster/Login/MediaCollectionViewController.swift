//
//  MediaCollectionViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 25/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

private let reuseIdentifier = "collectionCell"

class MediaCollectionViewController: UICollectionViewController, UINavigationControllerDelegate {
    @IBOutlet var addMediaButton: UIButton!
    var collectionItems = [String]()
    private var profileImage: UIImage?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setCollectionItems()
//        addMediaButton.layer.cornerRadius = 5
    }
    
    @objc private func handlePlusMedia() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func setCollectionItems() {NSLog("setCollectionItems")
        collectionItems = ["fruit01.png", "fruit02.png", "fruit03.png", "fruit04.png",
        "fruit05.png", "fruit06.png", "fruit07.png", "fruit08.png",]

    }

//    @IBAction func addMediaPressed(_ sender: UIButton) {
//        handlePlusMedia()
//    }

    // MARK: - CollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
        
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionItems.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! MediaCollectionViewCell
        
        cell.imageView.image = UIImage(named: collectionItems[indexPath.row])
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
        
    }

    
}

extension MediaCollectionViewController: UICollectionViewDelegateFlowLayout {
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
extension MediaCollectionViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        print(info)
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            profileImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            profileImage = originalImage
        }

        dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
