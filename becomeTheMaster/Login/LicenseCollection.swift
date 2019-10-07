//
//  LicenseCollection.swift
//  portfolioTabBar
//
//  Created by Loho on 26/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

let licenseReuseIdentifier = "LicenseCell"

class LicenseCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var reloadDataCompletionBlock: (() -> Void)?
    
    func reloadDataWithCompletion(_ completion:@escaping () -> Void) {
        reloadDataCompletionBlock = completion
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let block = self.reloadDataCompletionBlock {
            block()
        }
    }
    
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    var collectionItems = [String]()
    var licenseImageArray = [UIImage]()
    
    func licenseSetCollectionItems() {NSLog("setCollectionItems")
        _ = licenseImageArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return licenseImageArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: licenseReuseIdentifier, for: indexPath) as! LicenseCell
//        cell.licenseImageView.image = UIImage(named: collectionItems[indexPath.row])
        cell.licenseImageView.image = licenseImageArray[indexPath.row]
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

extension LicenseCollection: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = collectionView.frame.width / 5 - 1
        
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellWidth)
    }
    
    //Top & Bottom Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    //Side Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
}
