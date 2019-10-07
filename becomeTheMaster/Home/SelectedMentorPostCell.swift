//
//  SelectedMentorPostCell.swift
//  portfolioTabBar
//
//  Created by Loho on 13/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

protocol PostCellDelegate {
    func didLike(for cell: SelectedMentorPostCell)
}

class SelectedMentorPostCell: UICollectionViewCell {
    
    var delegate: PostCellDelegate?
    
    var post: Post? {
        didSet {
            configurePost()
        }
    }
    
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postImageView: CustomImageView!
    @IBOutlet var postSectionView: UIView!
    
    let padding: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configurePost() {
        guard let post = post else { return }
//        header.user = post.user
//        print(post)
        self.postImageView.loadImage(urlString: post.imageUrl)

//        print(post.imageUrl)
        self.likeButton.setImage(post.likedByCurrentUser == true ? #imageLiteral(resourceName: "likePressed").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like").withRenderingMode(.alwaysOriginal), for: .normal)
        
        let timeAgoDisplay = post.creationDate.timeAgoDisplay()
        self.timeLabel.text = timeAgoDisplay
        
        self.postTextView.text = post.caption
        
        self.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
//        setLikes(to: post.likes)
//        setupAttributedCaption()
        self.likeLabel.text = String("\(post.likes) likes")
    }
    
    @objc private func handleLike() {
        delegate?.didLike(for: self)
    }

}
