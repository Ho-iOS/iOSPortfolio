//
//  newMessageFollowTableView.swift
//  portfolioTabBar
//
//  Created by Loho on 28/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableView: UITableViewController {

    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.users.removeAll()
        self.fetchFollowingUser()
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = UIColor.colorWithRGBHex(hex: 0x405888)
        
        
        
    }

    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    
    func fetchFollowingUser() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        tableView?.refreshControl?.beginRefreshing()
        
        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (uid, value) in
                Database.database().fetchUser(withUID: uid, completion: {(user) in
                    self.users.append(user)
                    self.users.sort(by: { (user1, user2) -> Bool in
                        return user1.username!.compare(user2.username!) == .orderedDescending
                    })
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                })
            })
        }) { (err) in
            self.tableView?.refreshControl?.endRefreshing()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let messageLogController = MessageLogController(collectionViewLayout: UICollectionViewFlowLayout())
        messageLogController.selectedFollowUser = self.users[indexPath.item]
        
        messageLogController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(messageLogController, animated: true)
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMessageCell", for: indexPath) as! NewMessageTableCell
        
        cell.user = users[indexPath.item]
        cell.profileImageView.layer.cornerRadius = 5

        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
