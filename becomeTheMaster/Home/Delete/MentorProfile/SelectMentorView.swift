//
//  SelectMentorView.swift
//  portfolioTabBar
//
//  Created by Loho on 09/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class SelectMentorView: UIViewController {
//    @IBOutlet var profileTabCollection: ProfileTabCollectionView!
//    @IBOutlet var profileViewCollection: ProfileViewCollectionView!
//    @IBOutlet var selectedMentorTableView: UITableView!
    
//    let profileImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        selectedMentorTableView.estimatedRowHeight = 50
//        selectedMentorTableView.contentInset = UIEdgeInsets(top: 300, left: 0, bottom: 0, right: 0)
//        selectedMentorTableView.backgroundColor = UIColor.darkGray
        
        
//        setUpProfileImage()
        
    }
    
//    func setUpProfileImage() {
//        profileImageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300)
//        profileImageView.image = UIImage.init(named: "poster")
//        profileImageView.contentMode = .scaleAspectFill
//        profileImageView.clipsToBounds = true
//        view.addSubview(profileImageView)
//    }
}

//extension SelectMentorView: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            let cell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileTabTableCell")
//            cell?.anchor(height: 60)
//        default:
//            let cell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileViewTableCell")
//            cell?.anchor(height: UITableView.automaticDimension)
//        }
//        return UITableView.automaticDimension
//    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let tabcell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileTabTableCell")
//        let viewcell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileViewTableCell")
//
//        return tabcell, viewcell
//        let rowIndex = indexPath.row
//        if rowIndex == 0 {
//            let cell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileImageTableCell") as! ProfileImageTableCell
//            return cell
//        } else if rowIndex == 1 {
//            let cell = selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileTabTableCell") as! ProfileTabTableCell
//            return cell
//        } else {
//            let cell =  selectedMentorTableView.dequeueReusableCell(withIdentifier: "profileViewTableCell") as! ProfileViewTableCell
//            return cell
//        }
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = 300 - (scrollView.contentOffset.y + 300)
//        let height = min(max(y, 200), 400)
//        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
//    }
//}
