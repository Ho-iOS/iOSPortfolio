//
//  Request.swift
//  portfolioTabBar
//
//  Created by Loho on 29/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//


import UIKit
import Firebase

struct Request {
    
    var fromUid: String?
    var toUid: String?
    var timestamp: Date
    var kindOf: String?
    var aim: String?
    var skill: String?
    var people: String?
    var day: String?
    var time: String?
    var age: String?
    var sex: String?
    var startDate: String?
    var location: String?
    var hope: String?
    
    init(dictionary: [String: Any]) {
        self.fromUid = dictionary["fromUid"] as? String
        self.toUid = dictionary["toUid"] as? String
        let secondsFrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        
        self.kindOf = dictionary["kindOf"] as? String
        self.aim = dictionary["aim"] as? String
        self.skill = dictionary["skill"] as? String
        self.people = dictionary["people"] as? String
        self.day = dictionary["day"] as? String
        self.time = dictionary["time"] as? String
        self.age = dictionary["age"] as? String
        self.sex = dictionary["sex"] as? String
        self.startDate = dictionary["startDate"] as? String
        self.location = dictionary["location"] as? String
        self.hope = dictionary["hope"] as? String
        
    }
    
    func contractPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
    
}
