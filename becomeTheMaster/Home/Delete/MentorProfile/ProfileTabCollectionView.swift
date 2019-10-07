//
//  ProfileTabCollectionView.swift
//  portfolioTabBar
//
//  Created by Loho on 09/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class ProfileTabCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionItems = ["About", "Follow", "Review", "Post"]
    var collectionCounts = ["1","2","3","4"]
    func profileTabSetCollectionItems() {NSLog("setCollectionItems")
        _ = collectionItems
    }
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profileTabCollectionCell", for: indexPath) as! ProfileTabCollectionCell
        cell.profileCategoryLabel.text = collectionItems[indexPath.row]
        cell.profileCountLabel.text = collectionCounts[indexPath.row]
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
    
    
}

extension ProfileTabCollectionView: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = collectionView.frame.width / 4 - 1
        
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
