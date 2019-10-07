//
//  FirebaseUtilities.swift
//  portfolioTabBar
//
//  Created by Loho on 30/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

extension Auth {
    // Mark: - Auth Create Mentor
    func createMentor(withEmail email: String, username: String, nickname: String, password: String, profileImage: UIImage?, completion: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create user:", err)
                completion(err)
                return
            }
            guard let uid = user?.user.uid else { return }
            if let profileImage = profileImage {
                Storage.storage().uploadUserProfileImage(profileImage: profileImage, completion: { (profileImageUrl) in
                    self.uploadMentor(withUID: uid, username: username, nickname: nickname, profileImageUrl: profileImageUrl) {
                        completion(nil)
                    }
                })
            } else {
                self.uploadMentor(withUID: uid, username: username, nickname: nickname) {
                    completion(nil)
                }
            }
        })
    }
    private func uploadMentor(withUID uid: String, username: String, nickname: String?, profileImageUrl: String? = nil, completion: @escaping (() -> ())) {
        var dictionaryValues = ["username": username]
        if nickname != nil {
            dictionaryValues["nickname"] = nickname
        }
        if profileImageUrl != nil {
            dictionaryValues["profileImageUrl"] = profileImageUrl
        }
        
        let values = [uid: dictionaryValues]
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            completion()
        })
    }
    
    // Mark: - Auth Create Mentee
    func createMentee(withEmail email:String, username: String, nickname: String, password: String, profileImage: UIImage?, completion: @escaping (Error?) -> () ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, err) in
            if let err = err {
                print("Failed to create Mentee:", err)
                completion(err)
                return
            }
            guard let uid = user?.user.uid else {return}
            if let profileImage = profileImage {
                Storage.storage().uploadUserProfileImage(profileImage: profileImage, completion: { (profileImageUrl) in
                    self.uploadMentee(withUID: uid, username: username, nickname: nickname, profileImageUrl: profileImageUrl) {
                        completion(nil)
                    }
                })
            } else {
                self.uploadMentee(withUID: uid, username: username, nickname: nickname) {
                    completion(nil)
                }
            }
        })
        
    }
    private func uploadMentee(withUID uid: String, username: String, nickname: String?, profileImageUrl: String? = nil, completion: @escaping (() -> ())) {
        var dictionaryValues = ["username": username]
        if nickname != nil {
            dictionaryValues["nickname"] = nickname
        }
        if profileImageUrl != nil {
            dictionaryValues["profileImageUrl"] = profileImageUrl
        }
        
        let values = [uid: dictionaryValues]
        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
            if let err = err {
                print("Failed to upload user to database:", err)
                return
            }
            completion()
        })
        
    }
    
}


extension Storage {
    //MARK: - Custom FireBase Storage with Mentor SignUp
    func uploadUserProfileImage(profileImage: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = profileImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("profile_images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload profile image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for profile image:", err)
                    return
                }
                guard let profileImageUrl = downloadURL?.absoluteString else { return }
                completion(profileImageUrl)
            })
        })
    }
    
//    func uploadUserMediaImage(mediaImage: UIImage, completion: @escaping (String) -> ()) {
//        guard let uploadData = mediaImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
//
//        let storageRef = Storage.storage().reference().child("media_Images").child(NSUUID().uuidString)
//
//        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
//            if let err = err {
//                print("Failed to upload media image:", err)
//                return
//            }
//
//            storageRef.downloadURL(completion: { (downloadURL, err) in
//                if let err = err {
//                    print("Failed to obtain download url for media image:", err)
//                    return
//                }
//                guard let mediaImageUrl = downloadURL?.absoluteString else { return }
//                completion(mediaImageUrl)
//            })
//        })
//    }
    
    func uploadToMessageImage(_ image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print("Failed to upload image:", error!)
                    return
                }
                
                ref.downloadURL(completion: { (url, err) in
                    if let err = err {
                        print(err)
                        return
                    }
                    
                    completion(url?.absoluteString ?? "")
                })
                
            })
        }
    }
    
    func uploadUserLicenseImage(licenseImage: UIImage, completion: @escaping (String) -> ()) {
        guard let uploadData = licenseImage.jpegData(compressionQuality: 1) else { return } //changed from 0.3
        
        let storageRef = Storage.storage().reference().child("license_Images").child(NSUUID().uuidString)
        
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload license image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for license image:", err)
                    return
                }
                guard let licenseImageUrl = downloadURL?.absoluteString else { return }
                completion(licenseImageUrl)
            })
        })
    }
    
    fileprivate func uploadPostImage(image: UIImage, filename: String, completion: @escaping (String) -> ()) {
        guard let uploadData = image.jpegData(compressionQuality: 1) else { return } //changed from 0.5
        
        let storageRef = Storage.storage().reference().child("post_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                print("Failed to upload post image:", err)
                return
            }
            
            storageRef.downloadURL(completion: { (downloadURL, err) in
                if let err = err {
                    print("Failed to obtain download url for post image:", err)
                    return
                }
                guard let postImageUrl = downloadURL?.absoluteString else { return }
                completion(postImageUrl)
            })
        })
    }
    
}

extension Database {
    
    //MARK: Users
    func fetchUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (err) in
            print("Failed to fetch user from database:", err)
        }
    }
    
    func fetchAllUsers(includeCurrentUser: Bool = true, completion: @escaping ([User]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var users = [User]()
            
            dictionaries.forEach({ (key, value) in
                if !includeCurrentUser, key == Auth.auth().currentUser?.uid {
                    completion([])
                    return
                }
                
                guard let userDictionary = value as? [String: Any] else { return }
                
                
                var user = User(uid: key, dictionary: userDictionary)
    
//                if let arrayTimeList:[String] = userDictionary["timeList"] as? [String] {
//                    user.dayTime = arrayTimeList
//                }
//
//                if let arrayLicenseList:[String] = userDictionary["licenseImage"] as? [String] {
//                    user.licenseImageUrl = arrayLicenseList
//                }
                
                users.append(user)
                
//                print(user)
                
            })
            
            users.sort(by: { (user1, user2) -> Bool in
                return user1.username!.compare(user2.username!) == .orderedAscending
            })
            completion(users)
            
        }) { (err) in
            print("Failed to fetch all users from database:", (err))
            cancel?(err)
        }
    }
    
    //MARK: Posts
    func createPost(withImage image: UIImage, caption: String, completion: @escaping (Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let userPostRef = Database.database().reference().child("posts").child(uid).childByAutoId()
        
        guard let postId = userPostRef.key else { return }
        
        Storage.storage().uploadPostImage(image: image, filename: postId) { (postImageUrl) in
            let values = ["imageUrl": postImageUrl, "caption": caption, "imageWidth": image.size.width, "imageHeight": image.size.height, "creationDate": Date().timeIntervalSince1970, "id": postId] as [String : Any]
            
            userPostRef.updateChildValues(values) { (err, ref) in
                if let err = err {
                    print("Failed to save post to database", err)
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func fetchPost(withUID uid: String, postId: String, completion: @escaping (Post) -> (), withCancel cancel: ((Error) -> ())? = nil) {
        guard let currentLoggedInUser = Auth.auth().currentUser?.uid else { return }
        
        let ref = Database.database().reference().child("posts").child(uid).child(postId)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let postDictionary = snapshot.value as? [String: Any] else { return }
            
            Database.database().fetchUser(withUID: uid, completion: { (user) in
                var post = Post(user: user, dictionary: postDictionary)
                post.id = postId
                
                //check likes
                Database.database().reference().child("likes").child(postId).child(currentLoggedInUser).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let value = snapshot.value as? Int, value == 1 {
                        post.likedByCurrentUser = true
                    } else {
                        post.likedByCurrentUser = false
                    }
                    
                    Database.database().numberOfLikesForPost(withPostId: postId, completion: { (count) in
                        post.likes = count
                        completion(post)
                    })
                }, withCancel: { (err) in
                    print("Failed to fetch like info for post:", err)
                    cancel?(err)
                })
            })
        })
    }
    
    func fetchAllPosts(withUID uid: String, completion: @escaping ([Post]) -> (), withCancel cancel: ((Error) -> ())?) {
        let ref = Database.database().reference().child("posts").child(uid)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else {
                completion([])
                return
            }
            
            var posts = [Post]()
            
            dictionaries.forEach({ (postId, value) in
                Database.database().fetchPost(withUID: uid, postId: postId, completion: { (post) in
                    posts.append(post)
                    
                    if posts.count == dictionaries.count {
                        completion(posts)
                    }
                })
            })
        }) { (err) in
            print("Failed to fetch posts:", err)
            cancel?(err)
        }
    }
    
    func deletePost(withUID uid: String, postId: String, completion: ((Error?) -> ())? = nil) {
        Database.database().reference().child("posts").child(uid).child(postId).removeValue { (err, _) in
            if let err = err {
                print("Failed to delete post:", err)
                completion?(err)
                return
            }
            Database.database().reference().child("likes").child(postId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to delete likes on post:", err)
                    completion?(err)
                    return
                }
                
                Storage.storage().reference().child("post_images").child(postId).delete(completion: { (err) in
                    if let err = err {
                        print("Failed to delete post image from storage:", err)
                        completion?(err)
                        return
                    }
                })
                completion?(nil)
            })
        }
    }
    
    //MARK: Estimate
    func sendEstimateToFollow(uid: String, withFollowId followID: String, moneyPerTime:String, price:String, text:String, completion: @escaping (Error?) -> ()) {
        let reference = Database.database().reference().child("estimates")
        let childRef = reference.childByAutoId()
        
        let values = ["timestamp": Date().timeIntervalSince1970, "toUid": followID, "fromUid": uid, "moneyPerTime": moneyPerTime, "price": price, "text": text] as [String: Any]
        
        childRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to send estimate:", err)
                completion(err)
                return
            }
            completion(nil)
        }
        guard let requestID = childRef.key else { return }
        
        let userEstimatesRef = Database.database().reference().child("user-estimates").child(uid).child(followID).child(requestID)
        userEstimatesRef.setValue(1)
        
        let recipientUserEstimatesRef = Database.database().reference().child("user-estimates").child(followID).child(uid).child(requestID)
        recipientUserEstimatesRef.setValue(1)
        
    }

    //MARK: Request
    func sendRequestToFollow(uid: String, withFollowId followID: String, kindOf: String, aim: String, skill: String, people: String, day: String, time: String, age: String, sex: String, startDate: String, location: String, hope: String, completion: @escaping (Error?) -> ()) {
        let reference = Database.database().reference().child("requests")
        let childRef = reference.childByAutoId()
        
        let values = ["timestamp": Date().timeIntervalSince1970, "toUid": followID, "fromUid": uid, "kindOf": kindOf, "aim": aim, "skill":skill, "people":people, "day":day, "time":time, "age":age, "sex":sex, "startDate":startDate, "location":location, "hope":hope] as [String: Any]
        
        childRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to send request:", err)
                completion(err)
                return
            }
            completion(nil)
        }
        guard let requestID = childRef.key else { return }
        
        let userRequestsRef = Database.database().reference().child("user-requests").child(uid).child(followID).child(requestID)
        userRequestsRef.setValue(1)
        
        let recipientUserRequestsRef = Database.database().reference().child("user-requests").child(followID).child(uid).child(requestID)
        recipientUserRequestsRef.setValue(1)
        
    }
    
    //MARK: Messages
    func addMessageToFollow(uid: String, withFollowId followID: String, text: String, completion: @escaping (Error?) -> ()) {
        let reference = Database.database().reference().child("messages")
        let childRef = reference.childByAutoId()

        let values = ["text": text, "timestamp": Date().timeIntervalSince1970, "toUid": followID, "fromUid": uid] as [String: Any]
        
        childRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add message:", err)
                completion(err)
                return
            }
            completion(nil)
        }
        guard let messageID = childRef.key else { return }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(followID).child(messageID)
        userMessagesRef.setValue(1)
        
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(followID).child(uid).child(messageID)
        recipientUserMessagesRef.setValue(1)

    }
    
    func addImageToFollow(uid: String, withFollowId followID: String, imageUrl: String, image: UIImage, completion: @escaping (Error?) -> ()) {
        let reference = Database.database().reference().child("messages")
        let childRef = reference.childByAutoId()
        
        let values = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height, "timestamp": Date().timeIntervalSince1970, "toUid": followID, "fromUid": uid] as [String: Any]
        
        childRef.updateChildValues(values) { (err, _) in
            if let err = err {
                print("Failed to add message:", err)
                completion(err)
                return
            }
            completion(nil)
        }
        guard let messageID = childRef.key else { return }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(followID).child(messageID)
        userMessagesRef.setValue(1)
        
        let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(followID).child(uid).child(messageID)
        recipientUserMessagesRef.setValue(1)
        
    }
    
    //MARK: Follow
    func isFollowingUser(withUID uid: String, completion: @escaping (Bool) -> (), withCancel cancel: ((Error) -> ())?) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
                completion(true)
            } else {
                completion(false)
            }
            
        }) { (err) in
//            print("Failed to check if following:", err)
            cancel?(err)
        }
    }
    
    func followUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        let values = [uid: 1]
        Database.database().reference().child("following").child(currentLoggedInUserId).updateChildValues(values) { (err, ref) in
            if let err = err {
                completion(err)
                return
            }
            
            let values = [currentLoggedInUserId: 1]
            Database.database().reference().child("followers").child(uid).updateChildValues(values) { (err, ref) in
                if let err = err {
                    completion(err)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func unfollowUser(withUID uid: String, completion: @escaping (Error?) -> ()) {
        guard let currentLoggedInUserId = Auth.auth().currentUser?.uid else { return }
        
        Database.database().reference().child("following").child(currentLoggedInUserId).child(uid).removeValue { (err, _) in
            if let err = err {
                print("Failed to remove user from following:", err)
                completion(err)
                return
            }
            
            Database.database().reference().child("followers").child(uid).child(currentLoggedInUserId).removeValue(completionBlock: { (err, _) in
                if let err = err {
                    print("Failed to remove user from followers:", err)
                    completion(err)
                    return
                }
                completion(nil)
            })
        }
    }
    
    func numberOfFollowersForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("followers").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func followersForUser(withUID uid: String, completion: @escaping (User) -> ()) {
        Database.database().reference().child("followers").child(uid).observe( .childAdded, with: {(snapshot) in
            let uid = snapshot.key
            self.fetchUser(withUID: uid, completion: {(user) in
                completion(user)
            })
        })
    }
    
    func numberOfFollowingForUser(withUID uid: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
    func numberOfLikesForPost(withPostId postId: String, completion: @escaping (Int) -> ()) {
        Database.database().reference().child("likes").child(postId).observeSingleEvent(of: .value) { (snapshot) in
            if let dictionaries = snapshot.value as? [String: Any] {
                completion(dictionaries.count)
            } else {
                completion(0)
            }
        }
    }
    
}
