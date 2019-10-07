//
//  DayTimeController.swift
//  portfolioTabBar
//
//  Created by Loho on 23/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class DayTimeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kHeaderSectionTag: Int = 6900;
    
    var limit:Int = 20
    var limitCount:Int = 0
    
    @IBOutlet var dayTimeTableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    let dayList = [ "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"]
    let timeList = [[ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ],
                                    [ "오전", "오후", "저녁", "새벽", "종일", "시간협의" ]]

    var namesIndex:Int = 0
    var selectedRow: Set<IndexPath> = []
    var selectedDayTime: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dayTimeTableView!.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let user = Auth.auth().currentUser {
            let uid = user.uid
            Database.database().reference().child("users").child(uid).child("timeList").setValue(selectedDayTime)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dayList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.timeList[section] as NSArray
            namesIndex = section
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.dayList.count != 0) {
            return self.dayList[section] as? String
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        if let img = applyNavGradient(colours: [ UIColor.colorWithHexString(hexStr: "#405888"), UIColor.colorWithHexString(hexStr: "#98B8DB")]) {
            header.contentView.backgroundColor = UIColor(patternImage: img)
        }
        header.contentView.layer.borderWidth = 0.5
        header.contentView.layer.borderColor = UIColor.white.cgColor
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "sandoll misaeng", size: 24)
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18));
        theImageView.image = UIImage(named: "Chevron-Dn-Wht")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(FieldController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as UITableViewCell
        let section = self.timeList[indexPath.section] as NSArray
        
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = section[indexPath.row] as? String
        cell.textLabel?.font = UIFont(name: "sandoll misaeng", size: 24)
        return cell
    }
    //    MARK: - List Select
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        print("selected  \(sectionItems[namesIndex][indexPath.row])")
        var strTemp = ""
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected{
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    if selectedRow.contains(indexPath) {
                        selectedRow.remove(indexPath)
                    }
                    for idx in 0 ..< limitCount {
                        if selectedDayTime[idx] == "\(dayList[namesIndex])-\(timeList[namesIndex][indexPath.row])" {
                            selectedDayTime.remove(at: idx)
                            limitCount -= 1
                            for index in 0 ..< limitCount {
                                if index == limitCount - 1 {
                                    strTemp += "\(selectedDayTime[index])"
                                } else {
                                    strTemp += "\(selectedDayTime[index])\n"
                                }
                            }
                            self.view.hideToast()
                            self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 시간")
                            return
                        }
                    }
                } else {
                    if limitCount >= limit {
                        let alertController = UIAlertController(title: "Oops", message:
                            "You are limited to \(limit) selections", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
                        }))
                        self.present(alertController, animated: true, completion: nil)
                        
                        return
                    }
                    cell.accessoryType = .checkmark
                    selectedRow.insert(tableView.indexPathForSelectedRow!)
                    limitCount += 1
                    print("Test SelectedRow: \(selectedRow)")
                    
                    selectedDayTime.append("\(dayList[namesIndex])-\(timeList[namesIndex][indexPath.row])")
                    
                    for index in 0 ..< limitCount {
                        if index == limitCount - 1 {
                            strTemp += "\(selectedDayTime[index])"
                        } else {
                            strTemp += "\(selectedDayTime[index])\n"
                        }
                    }
                    self.view.hideToast()
                    self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 시간")

                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!)
                tableViewExpandSection(section, imageView: eImageView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.timeList[section] as NSArray
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.dayTimeTableView!.beginUpdates()
            self.dayTimeTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.dayTimeTableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.timeList[section] as NSArray
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.dayTimeTableView!.beginUpdates()
            self.dayTimeTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.dayTimeTableView!.endUpdates()
            for i in indexesPath {
                if let cell = dayTimeTableView!.cellForRow(at: i) {
                    if selectedRow.contains(i) {
                        cell.accessoryType = .checkmark
                    } else {
                        cell.accessoryType = .none
                    }
                }
            }
        }
        
    }
    
}

