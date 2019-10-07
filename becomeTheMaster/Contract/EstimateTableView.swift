//
//  EstimateTableController.swift
//  portfolioTabBar
//
//  Created by Loho on 27/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class EstimateTableView: UITableView, UITableViewDataSource, UITableViewDelegate {

    var sendEstimates = [Estimate]()
    var sendEstimatesDictionary = [String: Estimate]()
    var receiveEstimates = [Estimate]()
    var receiveEstimatesDictionary = [String: Estimate]()
    var users = [User]()

    var navigationController = UINavigationController()

    var uid: String = ""

    var senderReceiver = "보낸목록"
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func observeUserEstimates() {
        self.refreshControl?.beginRefreshing()
        self.sendEstimates.removeAll()
        self.receiveEstimates.removeAll()
        let ref = Database.database().reference().child("user-estimates").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let userId = snapshot.key
            let uid = self.uid
            Database.database().reference().child("user-estimates").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                let estaimateId = snapshot.key
                self.fetchEstimateWithEstimateId(estaimateId)
                
            }, withCancel: nil)
            self.reloadData()
            self.refreshControl?.endRefreshing()
        }, withCancel: nil)
        self.refreshControl?.endRefreshing()
    }
    
    fileprivate func fetchEstimateWithEstimateId(_ estaimateId: String) {

        let estimatesReference = Database.database().reference().child("estimates").child(estaimateId)
        
        estimatesReference.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let estimate = Estimate(dictionary: dictionary)
                
                if self.uid == estimate.fromUid {
                    self.sendEstimates.append(estimate)
                } else {
                    self.receiveEstimates.append(estimate)
                }
                self.handleReloadTable()
            }
        }, withCancel: nil)
    }
    
    
    fileprivate func handleReloadTable() {
        //        self.requests = Array(self.requestsDictionary.values)
        
        self.sendEstimates.sort(by: { (e1, e2) -> Bool in
            return e1.timestamp.compare(e2.timestamp) == .orderedDescending
        })
        self.receiveEstimates.sort(by: { (e1, e2) -> Bool in
            return e1.timestamp.compare(e2.timestamp) == .orderedDescending
        })
        //this will crash because of background thread, so lets call this on dispatch_async main thread
        DispatchQueue.main.async(execute: {
            self.reloadData()
        })
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if senderReceiver == "보낸목록" {
            return sendEstimates.count
        } else {
            return receiveEstimates.count
        }
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "estimateCell", for: indexPath) as! EstimateTableCell
        
        // Configure the cell...
        var timeAgoDisplay = ""
        if senderReceiver == "보낸목록" {
            cell.estimate = sendEstimates[indexPath.row]
            timeAgoDisplay = sendEstimates[indexPath.row].timestamp.timeAgoDisplay()
        } else {
            cell.estimate = receiveEstimates[indexPath.row]
            timeAgoDisplay = receiveEstimates[indexPath.row].timestamp.timeAgoDisplay()
        }
        
        cell.timeLabel.text = timeAgoDisplay
        
        cell.profileImageView.layer.cornerRadius = 5
        cell.summaryTextView.isEditable = false
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contractStoryboard = UIStoryboard(name: "Contract", bundle: nil)
        let sendEstimateController = contractStoryboard.instantiateViewController(withIdentifier: "sendEstimateVC") as! SendEstimateController
        sendEstimateController.estimatePopUp = "PopUp"
        if senderReceiver == "보낸목록" {
            //            sendRequestController.request = sendRequests[indexPath.row]
        } else {
            sendEstimateController.estimate = receiveEstimates[indexPath.row]
            if let fromUid = receiveEstimates[indexPath.row].fromUid {
                Database.database().fetchUser(withUID: fromUid, completion: { (user) in
                    sendEstimateController.selectedUser = user
                })
            }
            
            navigationController.pushViewController(sendEstimateController, animated: true)
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
}
