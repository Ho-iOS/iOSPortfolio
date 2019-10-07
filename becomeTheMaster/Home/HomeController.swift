//
//  HomeMainController.swift
//  portfolioTabBar
//
//  Created by Loho on 08/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, SendDataDelegate {
    @IBOutlet var homeMentorCollection: HomeMentorCollection!
    
    var filterFlag = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        homeMentorCollection.navigationController = self.navigationController
        
        homeMentorCollection.reloadData()
        
//        print("filter - ##############################")
//        print(homeMentorCollection.filter)
//        print("user - ##############################")
//        print(homeMentorCollection.mentorUsers)
//        print("############################")
        
        print("Mentor Profile Loading..")
        fetchAllUsers()
        print("Success!!")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchAllUsers()
    }
    
    @IBAction func postAddBtnPressed(_ sender: UIBarButtonItem) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let selectedMentorView = homeStoryboard.instantiateViewController(withIdentifier: "postSelectorController") as? PostSelector
        self.navigationController?.pushViewController(selectedMentorView!, animated: true)
    }
    
    @IBAction func filterBtnPressed(_ sender: UIBarButtonItem) {
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let filterController = homeStoryboard.instantiateViewController(withIdentifier: "filterViewController") as? FilterViewController
        filterController?.delegate = self
        self.navigationController?.pushViewController(filterController!, animated: true)
    }
    
    @objc func popView(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    func sendData(rating: Double?, location: String?, field: String?, selectedDay: [Bool], selectedTime: [Bool], filterApplyFlag: Bool) {
        self.homeMentorCollection.filter.ratingValue = rating
        self.homeMentorCollection.filter.location = location
        self.homeMentorCollection.filter.field = field
        self.homeMentorCollection.filter.selectedDay = selectedDay
        self.homeMentorCollection.filter.selectedTime = selectedTime
        
        self.filterFlag = filterApplyFlag
        
//        fetchAllUsers()
        
    }
    //Filtering
    func filterApply(user: User) {
        
        //guard let rating = self.homeMentorCollection.filter.ratingValue else {return}
        
        var flag = false
        
        let dayList = [ "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
        let timeList = [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ]
        
        //Location Filtering
        var locationArr = [String]()
        guard let location = self.homeMentorCollection.filter.location else {return}
        if location != "" {
            locationArr = location.components(separatedBy: "\n")
            if let userLocation = user.location {
                if locationArr.contains(userLocation) { flag = true } else { flag = false }
            }
        }
        
        //Field Filtering
        var fieldArr = [String]()
        guard let field = self.homeMentorCollection.filter.field else {return}
        if field != "" {
            fieldArr = field.components(separatedBy: "\n")
            if let userField = user.field {
                if fieldArr.contains( userField ) { flag = true } else { flag = false }
            }
        }
        
        //Day & Time Filtering
        let day = self.homeMentorCollection.filter.selectedDay
        let time = self.homeMentorCollection.filter.selectedTime
        var dayTimeArr = [String]()
        for a in 0 ..< day.count {
            for b in 0 ..< time.count {
                if day[a] == true && time[b] == true {
                    dayTimeArr.append("\(dayList[a]) - \(timeList[b])")
                }
            }
        }
        
        if dayTimeArr.count > 0 {
            for i in 0 ..< dayTimeArr.count {
                if user.dayTime?.contains(dayTimeArr[i]) == true {
                    flag = true
                    break
                } else { flag = false }
            }
        }
        
        if flag == true {
            self.homeMentorCollection.mentorUsers.append(user)
        }
        if location == "" && field == "" && dayTimeArr.count <= 0 {
            
        }
    }
    
    private func fetchAllUsers() {
        
        self.homeMentorCollection.mentorUsers.removeAll()
        
        self.homeMentorCollection.refreshControl?.beginRefreshing()
        print(self.filterFlag)
        Database.database().fetchAllUsers(includeCurrentUser: false, completion: { (users) in
//            print(users)
            users.forEach({ (user) in
                self.homeMentorCollection.user.append(user)
                if user.who == "Mentor" {
                    if self.filterFlag == false {
                        self.homeMentorCollection.mentorUsers.append(user)
                    } else {
                        self.filterApply(user: user)
                    }
                }
                
            })
//            print(users)
//            self.filterFlag = false
            self.homeMentorCollection.reloadData()
            self.homeMentorCollection.refreshControl?.endRefreshing()
        }) { (_) in
            self.homeMentorCollection.refreshControl?.endRefreshing()
        }
    }

    
}
