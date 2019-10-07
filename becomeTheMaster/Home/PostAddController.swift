//
//  PostAddController.swift
//  portfolioTabBar
//
//  Created by Loho on 14/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

//#98B8DB
//#7394B9
//#4F6C9A
//#405888

import UIKit
import Firebase

class PostAddController: UIViewController {
    @IBOutlet var textView: PlaceHolderTextView!
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: UIImage?
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLayout()
        
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handleShare))
        
        imageView.image = selectedImage
    }
    
    func initLayout() {
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
        imageView.layer.cornerRadius = 5
        //Custom TextView
        textView.setBorder(width: 0.5, color: myColor, corner: 5)
        textView.placeholderLabel.text = "Add a caption..."
        textView.placeholderLabel.font = UIFont.systemFont(ofSize: 14)
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.autocorrectionType = .no
    }
    
    
    @objc private func handleShare() {
        guard let postImage = selectedImage else { return }
        guard let caption = textView.text else { return }
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        textView.isUserInteractionEnabled = false
        
        
        Database.database().createPost(withImage: postImage, caption: caption) { (err) in
            if err != nil {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.textView.isUserInteractionEnabled = true
                return
            }
            NotificationCenter.default.post(name: NSNotification.Name.updateHomeFeed, object: nil)
            NotificationCenter.default.post(name: NSNotification.Name.updateUserProfileFeed, object: nil)

            self.navigationController?.popToRootViewController(animated: true)
        }
    }
}
