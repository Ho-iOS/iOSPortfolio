//
//  MessageTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 20/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class MessageTableCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            configuration()
        }
    }
    
    @IBOutlet weak var messageLastTime: UILabel!
    @IBOutlet weak var messageLastMsg: UILabel!
    @IBOutlet weak var messageUserName: UILabel!
    @IBOutlet weak var messageProfileImageVIew: CustomImageView!
    
    
    
    static var messageCellID = "messageCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configuration() {
        if let id = message?.chatPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.messageUserName?.text = dictionary["username"] as? String
//                    self.messageLastMsg.text =
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.messageProfileImageVIew.loadImage(urlString: profileImageUrl)
                    }
                }
                
            }, withCancel: nil)
        }
    }

}
