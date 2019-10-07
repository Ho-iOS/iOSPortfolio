//
//  SelectedMentorView.swift
//  portfolioTabBar
//
//  Created by Loho on 12/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import MXSegmentedPager
import Firebase

class SelectedMentorView: MXSegmentedPagerController {
    
    var followButton:UIBarButtonItem?
    
    var followTableView: FollowTableView? = nil
    var followerCollectionView: SelectedMentorFollow? = nil
    
    var user: User?{
        didSet{
            configureUser()
        }
    }
    
    @IBOutlet var headerView: SelectedMentorHeaderView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadFollowButton()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user?.username
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.image = UIImage(named: "back.png")
        followButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(handleFollow))
        navigationItem.rightBarButtonItem = followButton
//        followButton?.image = UIImage(named: "following.png")
        reloadFollowButton()
        // Parallax Header
        segmentedPager.parallaxHeader.view = headerView
        segmentedPager.parallaxHeader.mode = .fill
        segmentedPager.parallaxHeader.height = 300
        segmentedPager.parallaxHeader.minimumHeight = view.safeAreaInsets.top
        
        //Segmented Control customization
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = UIColor.white
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black];
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.orange]
        segmentedPager.segmentedControl.selectionStyle = .fullWidthStripe
        segmentedPager.segmentedControl.selectionIndicatorColor = UIColor.orange
        
    
    }
    
    @objc private func handleFollow() {
        guard let userId = user?.uid else { return }
        
//        self.reloadFollowerForUser()
        
        if followButton?.image == UIImage(named: "following.png") {
            Database.database().followUser(withUID: userId) { (err) in
                if err != nil {
                    self.followButton?.image = UIImage(named: "unfollowing.png")
                    return
                }
                self.reloadFollowButton()
                self.reloadUserStats()
                
            }
            
        } else if followButton?.image == UIImage(named: "unfollowing.png") {
            Database.database().unfollowUser(withUID: userId) { (err) in
                if err != nil {
                    self.followButton?.image = UIImage(named: "following.png")
                    return
                }
                self.reloadFollowButton()
                self.reloadUserStats()
                
            }
        }
        self.reloadFollowerForUser()
    }
    
    private func reloadFollowButton() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else { return }
        self.reloadFollowerForUser()
//        let followTableView:FollowTableView
        
        Database.database().isFollowingUser(withUID: userId, completion: { (following) in
            if following {
                self.followButton?.image = UIImage(named: "unfollowing.png")
            } else {
                self.followButton?.image = UIImage(named: "following.png")
            }
        }) { (err) in
            
        }
    }
    private func reloadFollowerForUser() {
        self.followerCollectionView?.users.removeAll()
        self.followerCollectionView?.followersForUser()
    }
    
    private func reloadUserStats() {
        guard let uid = user?.uid else { return }
        
        followTableView?.users.removeAll()
        followTableView?.fetchFollowingUser()
        followTableView?.tableView.reloadData()
        
//        Database.database().numberOfPostsForUser(withUID: uid) { (count) in
//            self.postsLabel.setValue(count)
//        }
        
        Database.database().numberOfFollowersForUser(withUID: uid) { (count) in
//            self.followersLabel.setValue(count)
            
        }
        
        Database.database().followersForUser(withUID: uid, completion: {(user) in
            
        })
        
        Database.database().numberOfFollowingForUser(withUID: uid) { (count) in
//            self.followingLabel.setValue(count)
        }
    }
    
    @objc private func handleCancel() {
        //        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        segmentedPager.parallaxHeader.minimumHeight = 100
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "mx_page_1", let dest = segue.destination as? SelectedMentorFollow {
            self.followerCollectionView = dest
            dest.selectedMentorView = self
        }
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
//        return ["About", "Follow", "Post"][index]
        return ["About", "Follow", "Post", "Review"][index]
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, didScrollWith parallaxHeader: MXParallaxHeader) {
//        print("progress \(parallaxHeader.progress)")
    }
    
    func configureUser() {
        guard let user = user else { return }
//        print(user)
        if let profileImageUrl = user.profileImageUrl {
//            print(profileImageUrl)
//            print("!!!!!!!!!!")
            headerView.profileImageView.loadImage(urlString: profileImageUrl)

        } else {
            headerView.profileImageView.image = #imageLiteral(resourceName: "Chevron-Dn-Wht")
        }
    }
}
