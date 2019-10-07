//
//  PlaceHolderTextView.swift
//  portfolioTabBar
//
//  Created by Loho on 25/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class PlaceHolderTextView: UITextView {
    func setBorder(width:CGFloat, color:UIColor, corner: CGFloat) -> Void {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
        self.layer.cornerRadius = corner
    }
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4)
    }
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    @objc private func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}
