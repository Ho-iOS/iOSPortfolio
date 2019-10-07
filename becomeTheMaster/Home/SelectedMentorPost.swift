//
//  SelectedMentorPost.swift
//  portfolioTabBar
//
//  Created by Loho on 12/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class SelectedMentorPost: UICollectionViewController, PostCellDelegate {

    private var posts = [Post]()
    
    var user: User?
    //
    // User - uid & Post - postID, uid // optionButtonAction
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchPostForSelectedMentor()
        // Do any additional setup after loading the view.
    }
    
    private func fetchPostForSelectedMentor() {
//        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        guard let user = appDelegate.user else {return}

        collectionView?.refreshControl?.beginRefreshing()
        
//        Database.database().fetchAllPosts(withUID: currentLoggedInUserId, completion: { (posts) in
        Database.database().fetchAllPosts(withUID: user.uid, completion: { (posts) in
            self.posts.append(contentsOf: posts)
            
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self.collectionView?.reloadData()
            self.collectionView?.refreshControl?.endRefreshing()
        }) { (err) in
            self.collectionView?.refreshControl?.endRefreshing()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            if cell.isSelected {
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "postCell", for: indexPath) as! SelectedMentorPostCell
        
//        cell.likeButton.addTarget(self, action: #selector(likeButtonPressed(_:)), for: .touchUpInside)
//        cell.likeButton.addTarget(self, action: #selector(cell.handleLike), for: .touchUpInside)
        
//        cell.optionButton.addTarget(self, action: "optionButtonPressed:", for: .touchUpInside)
        
//        cell.postImageView.loadImage(urlString: posts[indexPath.item].imageUrl)
//        cell.postTextView.text = posts[indexPath.item].caption
        
//        let timeAgoDisplay = posts[indexPath.item].creationDate.timeAgoDisplay()
//        cell.timeLabel.text = timeAgoDisplay
        cell.post = posts[indexPath.row]
        
        
        cell.delegate = self
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.3
        
        return cell
    }
    
    var likeFlag: Bool = false
    
    @objc func likeButtonPressed(_ sender: UIButton) {
        likeFlag = !likeFlag
        if likeFlag {
            sender.setImage(UIImage(named: "likePressed.png"), for: .normal)
            
        } else {
            sender.setImage(UIImage(named: "like.png"), for: .normal)
        }
    }
    
    func didLike(for cell: SelectedMentorPostCell) {
        guard let indexPath = collectionView?.indexPath(for: cell) else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var post = posts[indexPath.item]
        
        if post.likedByCurrentUser {
            Database.database().reference().child("likes").child(post.id).child(uid).removeValue { (err, _) in
                if let err = err {
                    print("Failed to unlike post:", err)
                    return
                }
                post.likedByCurrentUser = false
                post.likes = post.likes - 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        } else {
            let values = [uid : 1]
            Database.database().reference().child("likes").child(post.id).updateChildValues(values) { (err, _) in
                if let err = err {
                    print("Failed to like post:", err)
                    return
                }
                post.likedByCurrentUser = true
                post.likes = post.likes + 1
                self.posts[indexPath.item] = post
                UIView.performWithoutAnimation {
                    self.collectionView?.reloadItems(at: [indexPath])
                }
            }
        }
    }
    
//    Post Delete Action
//
//    @objc func optionButtonPressed() {
//
//        func handleOption(post: Post) {
//            guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
//
//            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alertController.addAction(cancelAction)
//
//            if currentLoggedInUserId == post.user.uid {
//                if let deleteAction = deleteAction(forPost: post) {
//                    alertController.addAction(deleteAction)
//                }
//            }
//
//            //        else {
//            //            if let unfollowAction = unfollowAction(forPost: post) {
//            //                alertController.addAction(unfollowAction)
//            //            }
//            //        }
//
//            present(alertController, animated: true, completion: nil)
//        }
//    }
//
//    private func deleteAction(forPost post: Post) -> UIAlertAction? {
//        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return nil }
//
//        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
//
//            let alert = UIAlertController(title: "Delete Post?", message: nil, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (_) in
//
//                Database.database().deletePost(withUID: currentLoggedInUserId, postId: post.id) { (_) in
//                    if let postIndex = self.posts.firstIndex(where: {$0.id == post.id}) {
//                        self.posts.remove(at: postIndex)
//                        self.collectionView?.reloadData()
//                    }
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
//        })
//        return action
//    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SelectedMentorPost: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = self.view.bounds.width
        let height = width + width/2
        return CGSize(width: width , height: height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let dummyCell = SelectedMentorPostCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
//        dummyCell.post = posts[indexPath.item]
//        dummyCell.layoutIfNeeded()
//
//        var height: CGFloat = dummyCell.bounds.width
//        height += view.frame.width
//        height += 24 + 2 * dummyCell.padding //bookmark button + padding
//        height += dummyCell.postTextView.intrinsicContentSize.height + 8
//        return CGSize(width: view.frame.width, height: height)
//    }
    
    //Top & Bottom Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
    //Side Margin
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 1
    }
    
}
