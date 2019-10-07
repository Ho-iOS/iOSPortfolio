//
//  FollowTableView.swift
//  portfolioTabBar
//
//  Created by Loho on 20/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class FollowTableView: UITableViewController {
    
    var users = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        
        fetchFollowingUser()
        showEmptyStateViewIfNeeded()
        if users.count <= 0 {
            self.tableView.separatorStyle = .none
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let selectedMentorView = homeStoryboard.instantiateViewController(withIdentifier: "selectedMentorView") as! SelectedMentorView
        selectedMentorView.followTableView = self
        
//        self.tableView?.backgroundColor = .white
        
        tableView.backgroundColor = .white
        tableView?.backgroundView = FollowEmptyStateView()
        if users.count == 0 {
            self.tableView.separatorStyle = .none
        }
        tableView?.backgroundView?.alpha = 0
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleRefresh), name: NSNotification.Name.updateHomeFeed, object: nil)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
//        handleRefresh()
    }
    
    @objc private func handleRefresh() {
//        users.removeAll()
        fetchFollowingUser()
        showEmptyStateViewIfNeeded()
    }
    
    func showEmptyStateViewIfNeeded() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        Database.database().numberOfFollowingForUser(withUID: currentLoggedInUserId) { (followingCount) in
            if followingCount == 0 {
                print(followingCount)
                UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
                    self.tableView?.backgroundView?.alpha = 1
                    
                }, completion: nil)
                self.tableView.separatorStyle = .none
            } else {
                self.tableView?.backgroundView?.alpha = 0
                self.tableView.separatorStyle = .singleLine
            }
        }
    }
    
    func fetchFollowingUser() {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        self.users.removeAll()
        tableView.reloadData()
        tableView?.refreshControl?.beginRefreshing()
        Database.database().reference().child("following").child(currentLoggedInUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            
            userIdsDictionary.forEach({ (uid, value) in
                Database.database().fetchUser(withUID: uid, completion: {(user) in
                    self.users.append(user)
                    self.users.sort(by: { (user1, user2) -> Bool in
                        return user1.username!.compare(user2.username!) == .orderedDescending
                    })
                    self.tableView?.reloadData()
                    self.tableView?.refreshControl?.endRefreshing()
                })
//                self.tableView?.refreshControl?.endRefreshing()
            })
//            self.tableView?.refreshControl?.endRefreshing()
        }) { (err) in
            self.tableView?.refreshControl?.endRefreshing()
        }
        self.tableView?.refreshControl?.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let selectedMentorView = homeStoryboard.instantiateViewController(withIdentifier: "selectedMentorView") as? SelectedMentorView
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.user = users[indexPath.row]
        selectedMentorView!.user = users[indexPath.row]
        self.navigationController?.pushViewController(selectedMentorView!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //MessageAction
        let messageAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let messageLogController = MessageLogController(collectionViewLayout: UICollectionViewFlowLayout())
            messageLogController.selectedFollowUser = self.users[indexPath.item]
            messageLogController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(messageLogController, animated: true)
        })
        messageAction.image = UIImage(named: "message.png")
        messageAction.backgroundColor = UIColor.colorWithRGBHex(hex: 0x60C3FF)
        //MatchingAction
        let matchingAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            success(true)

            let contractStoryboard = UIStoryboard(name: "Contract", bundle: nil)
            let requestViewController = contractStoryboard.instantiateViewController(withIdentifier: "requestController") as! SendRequestController
            requestViewController.selectedUser = self.users[indexPath.row]
            requestViewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(requestViewController, animated: true)
        })
        
        matchingAction.image = UIImage(named: "request.png")
        matchingAction.backgroundColor = UIColor.colorWithRGBHex(hex: 0x5887F9)
        //UnfollowingAction
        let unfollowAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            success(true)
            let alertController = UIAlertController(title: "UnFollow", message:
                "Do you want to unfollow it?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                let userId = self.users[indexPath.item].uid
                Database.database().isFollowingUser(withUID: userId, completion: { (following) in
                    if following {
                        Database.database().unfollowUser(withUID: userId) { (err) in
                            if err != nil {
                                return
                            } else {
                                DispatchQueue.main.async(execute: {
                                    self.users.removeAll()
                                    self.fetchFollowingUser()
                                    if self.users.count <= 0 {
                                        self.tableView.separatorStyle = .none
                                    }
                                    self.showEmptyStateViewIfNeeded()
                                    self.tableView.reloadData()
                                })
                            }
                        }
                    }
                }) { (err) in
                    //
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancle", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        })
        
        unfollowAction.image = UIImage(named: "unfollowing.png")
        unfollowAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions:[unfollowAction,matchingAction,messageAction])

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FollowTableCell.followCellID, for: indexPath) as! FollowTableCell
        
        if indexPath.item < users.count {
            cell.user = users[indexPath.item]
            cell.followUserImageView.layer.cornerRadius = 5
            cell.selectionStyle = .none
            
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
        
    }
}
