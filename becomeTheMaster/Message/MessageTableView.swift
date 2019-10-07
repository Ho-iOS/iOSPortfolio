//
//  MessageTableView.swift
//  portfolioTabBar
//
//  Created by Loho on 20/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import FirebaseAuth
import FirebaseDatabase


// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

class MessageTableView: UITableViewController {
    
    var users = [User]()
    var uid = [String]()
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeUserMessages()
    }
    
    @IBAction func newMessage(_ sender: UIBarButtonItem) {
        let messageStoryboard = UIStoryboard(name: "Message", bundle: nil)
        let newMessageController = messageStoryboard.instantiateViewController(withIdentifier: "newMessageController") as! NewMessageTableView
        newMessageController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(newMessageController, animated: true)
    }
    
    func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId)
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    fileprivate func fetchMessageWithMessageId(_ messageId: String) {
        let messagesReference = Database.database().reference().child("messages").child(messageId)
        
        messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {

                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.handleReloadTable()
            }
        }, withCancel: nil)
    }
    
    
    fileprivate func handleReloadTable() {
        self.messages = Array(self.messagesDictionary.values)
        
        self.messages.sort(by: { (m1, m2) -> Bool in
            return m1.timestamp.compare(m2.timestamp) == .orderedDescending
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
//        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableCell.messageCellID, for: indexPath) as! MessageTableCell
        cell.message = messages[indexPath.item]
        
        cell.messageLastMsg.text = messages[indexPath.item].text
        let timeAgoDisplay = messages[indexPath.row].timestamp.timeAgoDisplay()
        cell.messageLastTime.text = timeAgoDisplay
        cell.messageProfileImageVIew.layer.cornerRadius = 5
//        cell.messageStatus.layer.cornerRadius = 6
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                let message = messages[indexPath.row]
                
                guard let chatPartnerId = message.chatPartnerId() else {
                    return
                }
                
                let ref = Database.database().reference().child("users").child(chatPartnerId)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dictionary = snapshot.value as? [String: AnyObject] else {
                        return
                    }
                                        
                    let messageStoryboard = UIStoryboard(name: "Message", bundle: nil)
                    let messageLogController = messageStoryboard.instantiateViewController(withIdentifier: "messageLogController") as! MessageLogController
                    messageLogController.selectedFollowUser = User(uid: self.messages[indexPath.item].fromUid!, dictionary: dictionary)
                    messageLogController.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(messageLogController, animated: true)
                }, withCancel: nil)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            success(true)
            let alertController = UIAlertController(title: "deleteAction", message:
                "Do you want to delete Message?", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: {action in
                guard let uid = Auth.auth().currentUser?.uid else {
                    return
                }
                
                let message = self.messages[indexPath.row]
                
                if let chatPartnerId = message.chatPartnerId() {
                    Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error, ref) in
                        
                        if error != nil {
                            print("Failed to delete message:", error!)
                            return
                        }
                        
                        self.messagesDictionary.removeValue(forKey: chatPartnerId)
                        self.handleReloadTable()
                    })
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancle", style: .default, handler: {action in
            }))
            self.present(alertController, animated: true, completion: nil)
        })
        
        deleteAction.image = UIImage(named: "delete.png")
        deleteAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
