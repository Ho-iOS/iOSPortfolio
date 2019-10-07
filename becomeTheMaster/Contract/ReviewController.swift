//
//  ReviewController.swift
//  portfolioTabBar
//
//  Created by Loho on 25/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Cosmos

class ReviewController: UIViewController {
    @IBOutlet var reviewRating: CosmosView!
    @IBOutlet var reviewTextField: UITextField!
    @IBOutlet var reviewToWhoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
    }
    
}
