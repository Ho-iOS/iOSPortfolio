//
//  SelectetProfileTable.swift
//  portfolioTabBar
//
//  Created by Loho on 11/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit


class SelectetProfileTable: UITableView, UITableViewDelegate, UITableViewDataSource{
    
    
    override func awakeFromNib() {
        self.delegate = self
        self.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
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

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowIndex = indexPath.row
        if rowIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileImageTableCell") as! ProfileImageTableCell
            cell.profileImage.image = UIImage(named: "poster.jpg")
            return cell
        } else if rowIndex == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileTabTableCell") as! ProfileTabTableCell
            return cell
        } else {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "profileViewTableCell") as! ProfileViewTableCell
            return cell
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let y = 300 - (scrollView.contentOffset.y + 300)
//        let height = min(max(y, 100), 400)
//        let cell = self.dequeueReusableCell(withIdentifier: "profileImageTableCell") as! ProfileImageTableCell
//        cell.profileImage.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: height)
        let y = 200 - (scrollView.contentOffset.y + 200)
        let h = max(60,y)
        let rect = CGRect(x: 0, y: 0, width: bounds.width, height: h)
        let cell = self.dequeueReusableCell(withIdentifier: "profileImageTableCell") as! ProfileImageTableCell
        cell.profileImage.frame = rect
    }

}
