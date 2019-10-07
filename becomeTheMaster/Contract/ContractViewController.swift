//
//  ContractViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 27/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class ContractViewController: UIViewController {
    @IBOutlet var sendReceiveSegment: UISegmentedControl!
    @IBOutlet var contractSegment: UISegmentedControl!
    @IBOutlet var estimateTableView: EstimateTableView!
    @IBOutlet var requestTableView: RequestTableView!

    override func viewWillAppear(_ animated: Bool) {
        requestTableView.uid = Auth.auth().currentUser!.uid
        estimateTableView.uid = Auth.auth().currentUser!.uid
        
        requestTableView.observeUserRequests()
    
        estimateTableView.observeUserEstimates()
        sendReceiveSegment.selectedSegmentIndex = 0
        contractSegment.selectedSegmentIndex = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTableView.navigationController = self.navigationController!
        estimateTableView.navigationController = self.navigationController!
        estimateTableView.isHidden = false
        requestTableView.isHidden = true
        
    }
    
    @IBAction func contractSegmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // Estimate TableView
            sendReceiveSegment.selectedSegmentIndex = 0
            estimateTableView.isHidden = false
            requestTableView.isHidden = true
            estimateTableView.observeUserEstimates()
            requestTableView.observeUserRequests()
        } else if sender.selectedSegmentIndex == 1 {
            // Request TableView
            sendReceiveSegment.selectedSegmentIndex = 0
            estimateTableView.isHidden = true
            requestTableView.isHidden = false
//            sendReceiveSegment.selectedSegmentIndex = 0
            
            estimateTableView.observeUserEstimates()
            requestTableView.observeUserRequests()
        }
    }
    
    @IBAction func seperateListSegmentChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            // Send List
            requestTableView.senderReceiver = "보낸목록"
            requestTableView.observeUserRequests()
            estimateTableView.senderReceiver = "보낸목록"
            estimateTableView.observeUserEstimates()
        } else if sender.selectedSegmentIndex == 1 {
            // Receive List
            requestTableView.senderReceiver = "받은목록"
            requestTableView.observeUserRequests()
            estimateTableView.senderReceiver = "받은목록"
            estimateTableView.observeUserEstimates()
        }
    }

}
