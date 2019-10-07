//
//  EstimateTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 27/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class EstimateTableCell: UITableViewCell {
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var userLocationLessonLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImageView: CustomImageView!
    
    var estimate: Estimate? {
        didSet {
            configuration()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configuration() {
        if let id = estimate?.contractPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usernameLabel?.text = dictionary["username"] as? String
                    var strTemp = ""
                    if let location = dictionary["location"] as? String {
                        strTemp += "\(location)"
                    }
                    if let field = dictionary["field"] as? String {
                        if strTemp == "" {
                            strTemp += "\(field)"
                        } else {
                            strTemp += ", \(field)"
                        }
                    }
                    self.userLocationLessonLabel.text = strTemp
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImage(urlString: profileImageUrl)
                    }
//                    self.userLocationLessonLabel.text = "\((self.request?.location)!), \(field)"
                    var str = ""
                    if let timePerMoney = self.estimate?.timePerMoney {
                        str += "\(timePerMoney)"
                    }
                    if let price = self.estimate?.price {
                        if str == "" {
                            str += "\(price)"
                        } else {
                            str += ", \(price)"
                        }
                    }
                    if let text = self.estimate?.text {
                        if str == "" {
                            str += "\(text)"
                        } else {
                            str += ", \(text)"
                        }
                    }
                    self.summaryTextView.text = str
                }
                
            }, withCancel: nil)
        }
    }

}
