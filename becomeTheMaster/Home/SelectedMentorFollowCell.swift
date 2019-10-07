//
//  selectedMentorFollowCell.swift
//  portfolioTabBar
//
//  Created by Loho on 13/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class SelectedMentorFollowCell: UICollectionViewCell {
    
    var user: User? {
        didSet {
            configureCell()
        }
    }
    
    @IBOutlet var profileImageView: CustomImageView!
    @IBOutlet var userNameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configureCell() {
        userNameLabel.text = user?.username
        if let profileImageUrl = user?.profileImageUrl {
            profileImageView.loadImage(urlString: profileImageUrl)
        } else {
            profileImageView.image = #imageLiteral(resourceName: "Chevron-Dn-Wht")
        }
    }
}
