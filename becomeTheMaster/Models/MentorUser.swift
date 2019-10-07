//
//  Mentor.swift
//  portfolioTabBar
//
//  Created by Loho on 01/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import Foundation

struct MentorUser{
    let who:String?
    let uid: String
    let username: String
    let nickname: String
    let profileImageUrl: String?
    let phoneNumber: String
    let location: [String]
    let field: [String]
    let dayTime: [String]
    let about: String?
    let licenseImageUrl: [String]?
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.who = dictionary["who"] as? String
        self.username = dictionary["username"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.phoneNumber = dictionary["phoneNumber"] as! String
        self.location = dictionary["loaction"] as! [String]
        self.field = dictionary["field"] as! [String]
        self.dayTime = dictionary["dayTime"] as! [String]
        self.about = dictionary["about"] as? String ?? nil
        self.licenseImageUrl = dictionary["licenseImageUrl"] as? [String] ?? nil
        
    }
}
