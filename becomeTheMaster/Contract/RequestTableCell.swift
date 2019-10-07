//
//  RequestTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 27/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class RequestTableCell: UITableViewCell {
    @IBOutlet var summaryTextView: UITextView!
    @IBOutlet var userLocationLessonLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImageView: CustomImageView!
    
    var request: Request? {
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

        // Configure the view for the selected state
    }

    func configuration() {
        if let id = request?.contractPartnerId() {
            let ref = Database.database().reference().child("users").child(id)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    self.usernameLabel?.text = dictionary["username"] as? String
                    if let profileImageUrl = dictionary["profileImageUrl"] as? String {
                        self.profileImageView.loadImage(urlString: profileImageUrl)
                    }
                    guard let field = dictionary["field"] as? String else {return}
                    self.userLocationLessonLabel.text = "\((self.request?.location)!), \(field)"
                    self.summaryTextView.text = "\((self.request?.kindOf)!), \((self.request?.aim)!), \((self.request?.skill)!), \((self.request?.people)!), \((self.request?.day)!), \((self.request?.time)!), \((self.request?.age)!), \((self.request?.sex)!), \((self.request?.startDate)!), \((self.request?.location)!), \((self.request?.hope)!)"
                }
                
            }, withCancel: nil)
        }
    }
    
}
