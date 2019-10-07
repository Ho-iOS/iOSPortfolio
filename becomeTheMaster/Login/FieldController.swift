//
//  FieldController.swift
//  portfolioTabBar
//
//  Created by Loho on 23/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase
import Toast_Swift

class FieldController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let kHeaderSectionTag: Int = 6900;
    
    var limit:Int = 1
    var limitCount:Int = 0
    
    @IBOutlet var fieldTableView: UITableView!
    
    var expandedSectionHeaderNumber: Int = -1
    var expandedSectionHeader: UITableViewHeaderFooterView!
    
    let fieldList = [ "스포츠 / 건강", "학업", "대학 입시 / 취업 준비", "외국어", "연기 / 보컬 / 댄스", "악기", "요리 / 조리" ];
    let fieldDetailList = [ ["필라테스", "요가", "수영", "골프", "볼링", "당구", "축구", "야구", "농구", "배구", "테니스", "스쿼시 / 라켓볼", "클라이밍", "검도", "체조", "마라톤 / 육상", "태권도", "복싱", "킥복싱 / 무에타이", "주짓수", "종합격투기", "유도", "합기도", "호신술", "공수도(가라데)", "파쿠르", "웨이크보드", "스케이트보드", "서핑"],
                            ["영어", "수학", "과학", "국어", "사회", "한자", "논술", "검정고시"],
                            ["편입", "대학 입시&자소서 컨설팅", "유학 컨설팅", "커리어 컨설팅", "이력서/자소서 컨설팅", "인적성 / 필기시험", "면접", "스피치"],
                            ["영어", "중국어", "일본어", "프랑스어(불어)", "독일어(독어)", "러시아어", "라틴어", "네덜란드어", "몽골어", "베트남어", "스웨덴어", "아랍어", "이탈리아어", "체코어", "터키어", "포르투갈어", "폴란드어", "헝가리어"],
                            ["연기", "뮤지컬", "작사 / 편곡", "보컬트레이닝", "음향 / 레코딩", "스트릿댄스", "얼반댄스", "발레", "현대무용", "한국무용", "댄스스포츠", "살사댄스", "밸리댄스", "스윙댄스", "줌바댄스", "재즈댄스", "아르헨티나 탱고", "훌라댄스", "폴 댄스", "탭 댄스"],
                            ["기타", "피아노", "드럼", "색소폰", "트럼펫", "트롬본", "튜바", "호른", "우쿨렐레", "만돌린", "오카리나", "하모니카", "리코더", "팬플룻", "아코디언", "오르간"],
                            ["한식", "양식", "일식", "중식", "제과제빵", "커피(바리스타)", "와인(소믈리에)"]]
    
    var namesIndex:Int = 0
    var selectedRow: Set<IndexPath> = []
    var selectedField: [String] = []
    
    var visitedWhatScreen: String = ""
    var fieldStr = ""
    
    var filterVC: FilterViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLimit()
        self.fieldTableView!.tableFooterView = UIView()
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
                for idx in 0 ..< selectedField.count {
                    if idx == 0 {
                        fieldStr += "\(selectedField[idx])"
                    } else {
                        fieldStr += "\n\(selectedField[idx])"
                    }
                }
                filterVC?.fieldTemp = fieldStr
            } else {
                if let str:String = selectedField[0] {
                    Database.database().reference().child("users").child(user).child("field").setValue(str)
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
        return fieldList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.fieldDetailList[section] as NSArray
            namesIndex = section
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.fieldList.count != 0) {
            return self.fieldList[section] as? String
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
        let section = self.fieldDetailList[indexPath.section] as NSArray
        
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
                        if selectedField[idx] == "\(fieldList[namesIndex]) - \(fieldDetailList[namesIndex][indexPath.row])" {
                            selectedField.remove(at: idx)
                            limitCount -= 1
                            for index in 0 ..< limitCount {
                                if index == limitCount - 1 {
                                    strTemp += "\(selectedField[index])"
                                } else {
                                    strTemp += "\(selectedField[index])\n"
                                }
                            }
                            self.view.hideToast()
                            self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 분야")
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
                    
                    selectedField.append("\(fieldList[namesIndex]) - \(fieldDetailList[namesIndex][indexPath.row])")
                    for index in 0 ..< limitCount {
                        if index == limitCount - 1 {
                            strTemp += "\(selectedField[index])"
                        } else {
                            strTemp += "\(selectedField[index])\n"
                        }
                    }
                    self.view.hideToast()
                    self.view.makeToast("\(strTemp)", duration: 1.0, position: .bottom, title: "선택된 분야")
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
        let sectionData = self.fieldDetailList[section] as NSArray
        
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
            self.fieldTableView!.beginUpdates()
            self.fieldTableView!.deleteRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.fieldTableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView) {
        let sectionData = self.fieldDetailList[section] as NSArray
        
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
            self.fieldTableView!.beginUpdates()
            self.fieldTableView!.insertRows(at: indexesPath, with: UITableView.RowAnimation.fade)
            self.fieldTableView!.endUpdates()
            for i in indexesPath {
                if let cell = fieldTableView!.cellForRow(at: i) {
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

