//
//  MediaCollection.swift
//  portfolioTabBar
//
//  Created by Loho on 26/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

let mediaReuseIdentifier = "MediaCell"

class MediaCollection: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    var collectionItems = [String]()
    var mediaImageArray = [UIImage]()
    
    func mediaSetCollectionItems() {NSLog("setCollectionItems")
        _ = mediaImageArray
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaImageArray.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mediaReuseIdentifier, for: indexPath) as! MediaCell
        cell.mediaImageView.image = mediaImageArray[indexPath.row]
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        return cell
    }
}

extension MediaCollection: UICollectionViewDelegateFlowLayout {
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
