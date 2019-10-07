//
//  newMessageFollowTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 28/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class NewMessageTableCell: UITableViewCell {
    @IBOutlet var userFieldLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var profileImageView: CustomImageView!
    
    var user: User? {
        didSet {
            configureCell()
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
    
    private func configureCell() {
        usernameLabel.text = user?.username
        userFieldLabel.text = user?.field
        if let profileImageUrl = user?.profileImageUrl {
            profileImageView.loadImage(urlString: profileImageUrl)
        } else {
            profileImageView.image = #imageLiteral(resourceName: "Chevron-Dn-Wht")
        }
    }
}
