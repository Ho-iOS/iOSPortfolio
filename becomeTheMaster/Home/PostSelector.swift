//
//  PostSelector.swift
//  portfolioTabBar
//
//  Created by Loho on 14/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Photos

class PostSelector: UICollectionViewController {

    private var selectedImage : UIImage?
    private var images = [UIImage]()
    private var assets = [PHAsset]()
    
    private var header: PostHeaderCell?
    
    override var prefersStatusBarHidden: Bool { return true }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //화면 구성 상단 부분
        collectionView?.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))
        
        self.collectionView!.register(PostSubCell.self, forCellWithReuseIdentifier: PostSubCell.subId) // as! PostSubCell
        self.collectionView!.register(PostHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PostHeaderCell.headerId)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        fetchPhotos()
    }
    
    private func assetFetchOptions() -> PHFetchOptions {
        let fetchOptions = PHFetchOptions()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        return fetchOptions
    }
    
    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: assetFetchOptions())
        
        collectionView?.refreshControl?.beginRefreshing()
        DispatchQueue.global().async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image {
                        
                        self.images.append(image)
                        self.assets.append(asset)
                        
                    }
                    if self.selectedImage == nil {
//                        self.selectedImage = self.images[0]
                        self.selectedImage = image
                    }
//                    print(image)
                    if count == allPhotos.count - 1 {
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                            self.collectionView?.refreshControl?.endRefreshing()
                        }
                    }
                })
            }
        }
    }
    
    @objc private func handleCancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleNext() {
        
        if let postAddController = storyboard?.instantiateViewController(withIdentifier: "postAddVC") as? PostAddController {
            postAddController.selectedImage = header!.photoImageView.image
            navigationController?.pushViewController(postAddController, animated: true)
        }
        
//        let postAddController = PostAddController()
//        postAddController.selectedImage = header!.photoImageView.image
//        print("@@@@@@@@@@@@@@@@@")
//        print(postAddController.selectedImage)
//        navigationController?.pushViewController(postAddController, animated: true)
    }
    
    @objc private func handleRefresh() {
        selectedImage = nil
        images.removeAll()
        assets.removeAll()
        fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedImage = images[indexPath.item]
        self.selectedImage = selectedImage
        self.collectionView?.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PostHeaderCell.headerId, for: indexPath) as! PostHeaderCell
        
        
        self.header = header
        
        if let selectedImage = selectedImage {
            if let index = self.images.firstIndex(of: selectedImage) {
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFit, options: nil) { (image, info) in
//                    print(image)
                    header.photoImageView.image = image
                }
            }
        }
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PostSubCell.subId, for: indexPath) as! PostSubCell
        cell.photoImageView.image = images[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension PostSelector: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = self.view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
