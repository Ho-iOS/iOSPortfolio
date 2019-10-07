//
//  HomeMentorCollection.swift
//  portfolioTabBar
//
//  Created by Loho on 09/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

let mentorReuseIdentifier = "MentorCell"

struct filterStruct {
    var ratingValue:Double?
    var location:String?
    var field:String?
    var selectedDay = [Bool](repeating: false, count: 7)
    var selectedTime = [Bool](repeating: false, count: 6)
}

class HomeMentorCollection: UICollectionView , UICollectionViewDelegate, UICollectionViewDataSource{
 
    var filter = filterStruct()
    
    var user = [User]()
    var mentorUsers = [User]()
//    var filterUsers = [User]()
    
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return user.count
        return mentorUsers.count

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.isSelected {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.user = mentorUsers[indexPath.row]
                
                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
                let selectedMentorView = homeStoryboard.instantiateViewController(withIdentifier: "selectedMentorView") as? SelectedMentorView
                selectedMentorView!.user = mentorUsers[indexPath.row]
                
                self.navigationController?.pushViewController(selectedMentorView!, animated: true)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: mentorReuseIdentifier, for: indexPath) as! HomeMentorCell
        
        cell.mentorName.text = mentorUsers[indexPath.row].username
        cell.mentorFieldNLocation.text = mentorUsers[indexPath.row].field
        cell.mentorLocation.text = mentorUsers[indexPath.row].location
        
        if let profileImageUrl = mentorUsers[indexPath.row].profileImageUrl {
            cell.mentorProfileImageView.loadImage(urlString: profileImageUrl)
        } else {
            cell.mentorProfileImageView.image = #imageLiteral(resourceName: "poster.jpg")
        }

        
        cell.layer.cornerRadius = 3
        cell.clipsToBounds = true
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.white.cgColor
        
        return cell
    }
    
}

extension HomeMentorCollection: UICollectionViewDelegateFlowLayout {
    //Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewCellWidth = collectionView.frame.width
        
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
