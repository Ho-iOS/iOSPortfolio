//
//  RequestTableView.swift
//  portfolioTabBar
//
//  Created by Loho on 27/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class RequestTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
//    var requests = [Request]()
//    var requestsDictionary = [String: Request]()
    var sendRequests = [Request]()
    var sendRequestsDictionary = [String: Request]()
    var receiveRequests = [Request]()
    var receiveRequestsDictionary = [String: Request]()
    var users = [User]()
    
    var navigationController = UINavigationController()
    
//    let uid = Auth.auth().currentUser?.uid
    var uid: String = ""
    
    var senderReceiver = "보낸목록"
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func observeUserRequests() {
        self.refreshControl?.beginRefreshing()
        self.sendRequests.removeAll()
        self.receiveRequests.removeAll()
        let ref = Database.database().reference().child("user-requests").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            let uid = self.uid
            Database.database().reference().child("user-requests").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let requestId = snapshot.key
                self.fetchRequestWithRequestId(requestId)
                
            }, withCancel: nil)
            self.reloadData()
            self.refreshControl?.endRefreshing()
        }, withCancel: nil)
        self.refreshControl?.endRefreshing()
    }
    
    fileprivate func fetchRequestWithRequestId(_ requestId: String) {
        self.sendRequests.removeAll()
        self.receiveRequests.removeAll()
        let requestsReference = Database.database().reference().child("requests").child(requestId)
        
        requestsReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let request = Request(dictionary: dictionary)
                
//                if let contractPartnerId = request.contractPartnerId() {
//                    self.requestsDictionary[contractPartnerId] = request
//                }
                if self.uid == request.fromUid {
                    self.sendRequests.append(request)
                } else {
                    self.receiveRequests.append(request)
                }
//                self.requests.append(request)
                self.handleReloadTable()
            }
        }, withCancel: nil)
    }
    
    
    fileprivate func handleReloadTable() {
//        self.requests = Array(self.requestsDictionary.values)
        
        self.sendRequests.sort(by: { (r1, r2) -> Bool in
            return r1.timestamp.compare(r2.timestamp) == .orderedDescending
        })
        self.receiveRequests.sort(by: { (r1, r2) -> Bool in
            return r1.timestamp.compare(r2.timestamp) == .orderedDescending
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.reloadData()
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if senderReceiver == "보낸목록" {
            return sendRequests.count
        } else {
            return receiveRequests.count
        }
//        return requests.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestTableCell
        
        // Configure the cell...
        var timeAgoDisplay = ""
        if indexPath.item < sendRequests.count && senderReceiver == "보낸목록" {
            cell.request = sendRequests[indexPath.row]
            timeAgoDisplay = sendRequests[indexPath.row].timestamp.timeAgoDisplay()
        } else {
            if indexPath.item < receiveRequests.count {
                cell.request = receiveRequests[indexPath.row]
                timeAgoDisplay = receiveRequests[indexPath.row].timestamp.timeAgoDisplay()
            }
        }
        
//        cell.request = requests[indexPath.row]
 
        cell.timeLabel.text = timeAgoDisplay
//        cell.userLocationLessonLabel.text = "\(requests[indexPath.row].location!)"
        cell.profileImageView.layer.cornerRadius = 5
        cell.summaryTextView.isEditable = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contractStoryboard = UIStoryboard(name: "Contract", bundle: nil)
        let sendRequestController = contractStoryboard.instantiateViewController(withIdentifier: "requestController") as! SendRequestController
        sendRequestController.requestPopUp = "PopUp"
        if senderReceiver == "보낸목록" {
//            sendRequestController.request = sendRequests[indexPath.row]
        } else {
            sendRequestController.request = receiveRequests[indexPath.row]
            if let fromUid = receiveRequests[indexPath.row].fromUid {
                Database.database().fetchUser(withUID: fromUid, completion: { (user) in
                    sendRequestController.selectedUser = user
                })
            }
            navigationController.pushViewController(sendRequestController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
