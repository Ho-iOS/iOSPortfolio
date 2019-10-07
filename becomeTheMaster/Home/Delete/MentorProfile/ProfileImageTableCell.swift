//
//  ProfileImageTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 11/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class ProfileImageTableCell: UITableViewCell {
    @IBOutlet var profileImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setUpProfileImage()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setUpProfileImage() {
        profileImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
        profileImage.image = UIImage.init(named: "poster")
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
//        view.addSubview(profileImageView)
    }

    
}
