//
//  MessageLogController.swift
//  portfolioTabBar
//
//  Created by Loho on 21/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

private let reuseIdentifier = "messageLogCell"

class MessageLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let uid = Auth.auth().currentUser?.uid
    
    let imagePickerController = UIImagePickerController()
    
    var selectedFollowUser: User? {
        didSet {
            navigationItem.title = selectedFollowUser?.username
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toUid = selectedFollowUser?.uid else {
            return
        }
        print(uid)
        print(selectedFollowUser)
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toUid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.messages.append(Message(dictionary: dictionary))
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    //scroll to the last index
                    //                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    //                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                })
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    let sendButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "sendMessage.png")
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let uploadFileButton: UIButton = {
        let btn = UIButton()
        let image = UIImage(named: "attach.png")
        btn.setImage(image, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let sendTextView: PlaceHolderTextView = {
        let tv = PlaceHolderTextView()
        tv.placeholderLabel.text = "Enter Message.."
        tv.placeholderLabel.font = UIFont.systemFont(ofSize: 16)
        tv.autocorrectionType = .no
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func navTitleSetupComponent() {
        self.navigationItem.title = selectedFollowUser?.username
//        if let imageUrl = self.selectedFollowUser?.profileImageUrl {
//            var imageView:CustomImageView!
//            imageView.loadImage(urlString: imageUrl)
//            self.navigationItem.titleView?.addSubview(imageView)
//            
//        }
        self.collectionView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        self.collectionView!.register(MessageLogCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView?.alwaysBounceVertical = true
        
        navTitleSetupComponent()
        setupInputComponent()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if view.frame.origin.y == 0 {
//                view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if view.frame.origin.y != 0 {
//            view.frame.origin.y = 0
//        }
//    }
    
    
    func setupInputComponent() {
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(uploadFileButton)
        uploadFileButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        uploadFileButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadFileButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        uploadFileButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        uploadFileButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendTextView)
        sendTextView.leftAnchor.constraint(equalTo: uploadFileButton.rightAnchor).isActive = true
        sendTextView.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        sendTextView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendTextView.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        sendTextView.setBorder(width: 0.3, color: UIColor.darkGray, corner: 3)
        
//        collectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
    }
    
    @objc func handleSend() {
//        print(sendTextView.text!)
        
        Database.database().addMessageToFollow(uid: uid!, withFollowId: selectedFollowUser!.uid, text: sendTextView.text, completion: {(err) in
            if err != nil {
                return
            }
        })
        sendTextView.text = String()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageLogCell
        
        let message = messages[indexPath.item]
        
        cell.textView.text = message.text
//        let time = Date().timeIntervalSince1970 as? Double ?? 0
//        cell.messageTimeLabel.text = time.timeAgoDisplay()
        setupCell(cell, message: message)
        
        if let text = message.text {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
        }
//        let timeAgoDisplay = message.timestamp.timeAgoDisplay()
//        cell.messageTimeLabel.text = timeAgoDisplay
//        
        return cell
    }
    
    fileprivate func setupCell(_ cell: MessageLogCell, message: Message) {
        if let profileImageUrl = selectedFollowUser?.profileImageUrl {
            cell.profileImageView.loadImage(urlString: profileImageUrl)
        }
        if message.fromUid == Auth.auth().currentUser?.uid {
            //outgoing message
            cell.bubbleView.backgroundColor = MessageLogCell.blueColor
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.timeLabelRightAnchor?.isActive = true
        } else {
            //incoming message
            cell.bubbleView.backgroundColor = UIColor.colorWithRGBHex(hex: 0x405888)
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.timeLabelRightAnchor?.isActive = false
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImage(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messages[indexPath.item]
        if let text = message.text {
            height = estimateFrameForText(text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        }
        
        let width = self.view.frame.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    //Top & Bottom Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    //Side Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }

//    var startingFrame: CGRect?
//    var blackBackgroundView: UIView?
//    var startingImageView: UIImageView?
//    
//    //my custom zooming logic
//    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
//        
//        self.startingImageView = startingImageView
//        self.startingImageView?.isHidden = true
//        
//        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
//        
//        let zoomingImageView = UIImageView(frame: startingFrame!)
//        zoomingImageView.backgroundColor = UIColor.red
//        zoomingImageView.image = startingImageView.image
//        zoomingImageView.isUserInteractionEnabled = true
//        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
//        
//        if let keyWindow = UIApplication.shared.keyWindow {
//            blackBackgroundView = UIView(frame: keyWindow.frame)
//            blackBackgroundView?.backgroundColor = UIColor.black
//            blackBackgroundView?.alpha = 0
//            keyWindow.addSubview(blackBackgroundView!)
//            
//            keyWindow.addSubview(zoomingImageView)
//            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                
//                self.blackBackgroundView?.alpha = 1
//                
//                // math?
//                // h2 / w1 = h1 / w1
//                // h2 = h1 / w1 * w1
//                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
//                
//                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
//                
//                zoomingImageView.center = keyWindow.center
//                
//            }, completion: { (completed) in
//                //                    do nothing
//            })
//            
//        }
//    }
//    
//    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
//        if let zoomOutImageView = tapGesture.view {
//            //need to animate back out to controller
//            zoomOutImageView.layer.cornerRadius = 16
//            zoomOutImageView.clipsToBounds = true
//            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                
//                zoomOutImageView.frame = self.startingFrame!
//                self.blackBackgroundView?.alpha = 0
//                
//                
//            }, completion: { (completed) in
//                zoomOutImageView.removeFromSuperview()
//                self.startingImageView?.isHidden = false
//            })
//        }
//    }
    
}

extension MessageLogController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleUploadTap() {
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        handleImageSelectedForInfo(info as [String : AnyObject])
        
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func handleImageSelectedForInfo(_ info: [String: AnyObject]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            Storage.storage().uploadToMessageImage(selectedImage, completion: { (imageUrl) in
                Database.database().addImageToFollow(uid: self.uid!, withFollowId: self.selectedFollowUser!.uid, imageUrl: imageUrl, image: selectedImageFromPicker!, completion: {(err) in
                    if err != nil {
                        return
                    }
                })
            })
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
