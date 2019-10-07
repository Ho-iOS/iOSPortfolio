//
//  Message.swift
//  portfolioTabBar
//
//  Created by Loho on 21/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromUid: String?
    var text: String?
    var timestamp: Date
    var toUid: String?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    init(dictionary: [String: Any]) {
        self.fromUid = dictionary["fromUid"] as? String
        self.text = dictionary["text"] as? String
        self.toUid = dictionary["toUid"] as? String
        let secondsFrom1970 = dictionary["timestamp"] as? Double ?? 0
        self.timestamp = Date(timeIntervalSince1970: secondsFrom1970)
        
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
        
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        
        
    }
    
    func chatPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
    
}
