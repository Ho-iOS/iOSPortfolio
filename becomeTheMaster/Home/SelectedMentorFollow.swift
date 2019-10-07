//
//  SelectedMentorFollow.swift
//  portfolioTabBar
//
//  Created by Loho on 12/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class SelectedMentorFollow: UICollectionViewController {
    
    var users = [User]()
    var user: User?
    var selectedMentorView: SelectedMentorView? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        followersForUser()
    }
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        
    }
    func followersForUser() {
        users.removeAll()
        
        collectionView?.refreshControl?.beginRefreshing()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let uid = appDelegate.user?.uid {
            Database.database().followersForUser(withUID: uid, completion: { (user) in
                self.users.append(user)
                self.collectionView?.reloadData()
                self.collectionView?.refreshControl?.endRefreshing()
            })
        }
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.cellForItem(at: indexPath) {
//            if cell.isSelected {
//                let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
//                let selectedMentorView = homeStoryboard.instantiateViewController(withIdentifier: "selectedMentorView") as? SelectedMentorView
//                selectedMentorView!.user = users[indexPath.row]
//                self.navigationController?.pushViewController(selectedMentorView!, animated: true)
//                var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
//                navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
//                self.navigationController?.viewControllers = navigationArray!
//            }
//        }
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "followCell", for: indexPath) as! SelectedMentorFollowCell
        cell.user = users[indexPath.item]
//        cell.profileImageView.loadImage(urlString: users[indexPath.row].profileImageUrl!)
//        cell.userNameLabel.text = users[indexPath.row].username
        cell.profileImageView.layer.cornerRadius = 5
        
        return cell
    }

}

//MARK: - UICollectionViewDelegateFlowLayout

extension SelectedMentorFollow: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 76)
    }
}
