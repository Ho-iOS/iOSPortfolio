//
//  Estimate.swift
//  portfolioTabBar
//
//  Created by Loho on 29/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//


import UIKit
import Firebase

struct Estimate {
    
    var fromUid: String?
    var toUid: String?
    var timestamp: Date
    var timePerMoney: String?
    var price: String?
    var text: String?
    
    init(dictionary: [String: Any]) {
        self.fromUid = dictionary["fromUid"] as? String
        self.toUid = dictionary["toUid"] as? String
        let secondsFrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        
        self.timePerMoney = dictionary["timePerMoney"] as? String
        self.price = dictionary["price"] as? String
        self.text = dictionary["text"] as? String
        
    }
    
    func contractPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
    
}
