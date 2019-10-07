//
//  CityController.swift
//  portfolioTabBar
//
//  Created by Loho on 29/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class CityController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kHeaderSectionTag: Int = 6900;
    
    var limit:Int = 1
    var limitCount:Int = 0
    
    @IBOutlet var cityTableView: UITableView!
    
    let cityList = ["서울", "인천", "경기", "강원", "충북", "충남", "대전", "세종", "전북", "전남", "광주", "경북", "경남", "부산", "대구", "울산", "제주"]
    let cityUrbanList  = [["서울 전체","강남구","강동구","강북구","강서구","관악구","광진구","구로구","금천구","노원구","도봉구","동대문구","동작구","마포구","서대문구","서초구","성동구","성북구","송파구","양천구","영등포구","용산구","은평구","종로구","중구","중랑구"],
                          ["인천 전체","강화군","계양구","미추홀구","남동구","동구","부평구","서구","연수구","옹진군","중구"],
                          ["경기 전체","가평군","고양시","서구","과천시","광명시","광주시","구리시","군포시","김포시","남양주시","동두천시","부천시","성남시","수원시","시흥시","안산시","안성시","안양시","양주시","양평군","여주시","연천군","오산시","용인시","의왕시","의정부시","이천시","파주시","평택시","포천시","하남시","화성시"],
                          ["강원 전체","강릉시","고성군","동해시","삼척시","속초시","양구군","양양군","영월군","원주시","인제군","정선군","철원군","춘천시","태백시","평창군","홍천군","화천군","횡성군"],
                          ["괴산군","단양군","보은군","영동군","옥천군","음성군","제천시","증평군","진천군","청주시","충주시"],
                          ["계룡시","공주시","금산군","논산시","당진시","보령시","부여군","서산시","서천군","아산시","연기군","예산군","천안시","청양군","태안군","홍성군"],
                          ["대전 전체","대덕구","동구","서구","유성구","중구"],
                          ["세종"],
                          ["고창군","군산시","김제시","남원시","무주군","부안군","순창군","완주군","익산시","임실군","장수군","전주시","정읍시","진안군"],
                          ["강진군","고흥군","곡성군","광양시","구례군","나주시","담양군","목포시","무안군","보성군","순천시","신안군","여수시","영광군","영암군","완도군","장성군","장흥군","진도군","함평군","해남군","화순군"],
                          ["광주 전체","광산구","남구","동구","북구","서구"],
                          ["경산시","경주시","고령군","구미시","군위군","김천시","문경시","봉화군","상주시","성주군","안동시","영덕군","영양군","영주시","영천시","예천군","울릉군","울진군","의성군","청도군","청송군","칠곡군","포항시"],
                          ["거제시","거창군","고성군","김해시","남해군","밀양시","사천시","산청군","양산시","의령군","진주시","창녕군","창원시","통영시","하동군","함안군","함양군","합천군"],
                          ["부산 전체","강서구","금정구","기장군","남구","동구","동래구","부산진구","북구","사상구","사하구","서구","수영구","연제구","영도구","중구","해운대구"],
                          ["대구 전체","남구","달서구","달성군","동구","북구","서구","수성구","중구"],
                          ["울산 전체","남구","동구","북구","울주군","중구"],
                          ["제주 전체","서귀포시","제주시"]]
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    var visitedWhatScreen: String = ""
    var locationStr = ""
    
    var namesIndex:Int = 0
    var selectedRow: Set<IndexPath> = []
    var selectedCity: [String] = []
    
    var requestVC: SendRequestController? = nil
    var filterVC: FilterViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLimit()
        self.cityTableView!.tableFooterView = UIView()
    }

    func checkLimit() {
        if visitedWhatScreen == "Filter" {
            limit = 5
        } else {
            limit = 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let user = Auth.auth().currentUser?.uid {
            if visitedWhatScreen == "Filter" {
                for idx in 0 ..< selectedCity.count {
                    if idx == selectedCity.count - 1 {
                        locationStr += "\(selectedCity[idx])"
                    } else {
                        locationStr += "\(selectedCity[idx])\n"
                    }
                }
                filterVC?.locationTemp = locationStr
                
            } else if visitedWhatScreen == "request" {
                requestVC?.lessonLocationLabel.text = selectedCity[0]
            } else {
                if let str:String = selectedCity[0] {
                    Database.database().reference().child("users").child(user).child("location").setValue(str)
                }
            }
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Tableview Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.cityUrbanList[section] as NSArray
            namesIndex = section
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.cityList.count != 0) {
            return self.cityList[section] as String
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

        if let img = applyNavGradient(colours: [ UIColor.colorWithHexString(hexStr: "#405888"), UIColor.colorWithHexString(hexStr: "#FFFFFF")]) {
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
        let section = self.cityUrbanList[indexPath.section] as NSArray
        
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
//                        limitCount -= 1
                    }
                    
                    for idx in 0 ..< limitCount {
                        
                        if selectedCity[idx] == "\(cityList[namesIndex]) - \(cityUrbanList[namesIndex][indexPath.row])" {
                            selectedCity.remove(at: idx)
                            limitCount -= 1
                            
                            for index in 0 ..< limitCount {
                                if index == limitCount - 1 {
                                    strTemp += "\(selectedCity[index])"
                                } else {
                                    strTemp += "\(selectedCity[index])\n"
                                }
                                
                            }
                            
                            self.view.hideToast()
                            self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 지역")
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

                    selectedCity.append("\(cityList[namesIndex]) - \(cityUrbanList[namesIndex][indexPath.row])")
                    
                    for index in 0 ..< limitCount {
                        if index == limitCount - 1 {
                            strTemp += "\(selectedCity[index])"
                        } else {
                            strTemp += "\(selectedCity[index])\n"
                        }
                    }
                    
                    self.view.hideToast()
                    self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 지역")

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
        let sectionData = self.cityUrbanList[section] as NSArray
        
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
            self.cityTableView!.beginUpdates()
            self.cityTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.cityTableView!.endUpdates()
//            self.cityTableView.setNeedsDisplay()
        }
        
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.cityUrbanList[section] as NSArray
        
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
            self.cityTableView!.beginUpdates()
            self.cityTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.cityTableView!.endUpdates()
            for i in indexesPath {
                if let cell = cityTableView!.cellForRow(at: i) {
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

