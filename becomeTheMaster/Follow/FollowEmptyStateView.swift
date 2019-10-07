//
//  HomeEmptyStateCell.swift
//  InstagramClone
//
//  Created by Mac Gallagher on 8/13/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import UIKit

class FollowEmptyStateView: UIView {
    
    private let noPostsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "The pupil has become the master\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSMutableAttributedString(string: "When you follow people, you'll see the follow lists here.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        attributedText.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSRange(location: 0, length: attributedText.length))
        label.backgroundColor = UIColor.white
        label.attributedText = attributedText
        return label
    }()
    
    static var cellId = "followEmptyStateCellId"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        addSubview(noPostsLabel)
        noPostsLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 12, paddingRight: 12)
    }
    
}
