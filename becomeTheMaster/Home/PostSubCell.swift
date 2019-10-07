//
//  PostSubCell.swift
//  portfolioTabBar
//
//  Created by Loho on 14/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class PostSubCell: UICollectionViewCell {
//    @IBOutlet var postSubImageView: UIImageView!
//
//    static var subId = "postSubCell"
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    static var subId = "postSubCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
}
