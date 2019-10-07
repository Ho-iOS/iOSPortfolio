//
//  User.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 7/30/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Foundation

struct User {
//
//    let uid: String
//    let username: String
//    let nickname: String
//    let profileImageUrl: String?
//    let field: String?
//    let who:String?
//
//    init(uid: String, dictionary: [String: Any]) {
//        self.uid = uid
//        self.username = dictionary["username"] as? String ?? ""
//        self.nickname = dictionary["nickname"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
//        self.field = dictionary["field"] as? String ?? nil
//        self.who = dictionary["who"] as? String
//    }
    let who:String?
    let uid: String
    let username: String?
    let nickname: String?
    let profileImageUrl: String?
    let phoneNumber: String?
    let location: String?
    let field: String?
    var dayTime: [String]?
    let about: String?
    var licenseImageUrl: [String]?
    
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.who = dictionary["who"] as? String
        self.username = dictionary["username"] as? String ?? ""
        self.nickname = dictionary["nickname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.phoneNumber = dictionary["phoneNumber"] as? String ?? ""
        self.location = dictionary["location"] as? String
        self.field = dictionary["field"] as? String ?? ""
        self.dayTime = dictionary["timeList"] as? [String] ?? nil
        self.about = dictionary["about"] as? String ?? nil
        self.licenseImageUrl = dictionary["licenseImage"] as? [String] ?? nil
        
    }
}
