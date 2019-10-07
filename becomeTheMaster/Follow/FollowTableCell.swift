//
//  FollowTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 20/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FollowTableCell: UITableViewCell {
    @IBOutlet weak var followUserName: UILabel!
    @IBOutlet weak var followUserField: UILabel!
    @IBOutlet weak var followUserImageView: CustomImageView!
    
    var user: User? {
        didSet {
            configureCell()
        }
    }
    
    static var followCellID = "followCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func configureCell() {
        followUserName.text = user?.username
        if let field = user?.field {
            followUserField.text = field
        }
        if let profileImageUrl = user?.profileImageUrl {
            followUserImageView.loadImage(urlString: profileImageUrl)
        } else {
            followUserImageView.image = #imageLiteral(resourceName: "Chevron-Dn-Wht")
        }
    }

}
