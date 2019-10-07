//
//  MentorList.swift
//  portfolioTabBar
//
//  Created by Loho on 12/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//
import Foundation

struct MentorLists {
    
    let user: MentorUser
    let username: String
    let profileImageUrl: String?
    let location: [String]
    let field: [String]
//    let caption: String
//    let creationDate: Date
    
//    var likes: Int = 0
//    var likedByCurrentUser = false
    
    init(user: MentorUser, dictionary: [String: Any]) {
        self.user = user
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? nil
        self.username = dictionary["username"] as? String ?? ""
        self.field = dictionary["fieldList"] as? [String] ?? [""]
        self.location = dictionary["cityList"] as? [String] ?? [""]
//        self.caption = dictionary["caption"] as? String ?? ""
//        self.id = dictionary["id"] as? String ?? ""
//
//        let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
//        self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
    }
}
