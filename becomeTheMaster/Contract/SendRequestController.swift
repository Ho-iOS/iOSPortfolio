//
//  RequestController.swift
//  portfolioTabBar
//
//  Created by Loho on 25/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

class SendRequestController: UIViewController {
    @IBOutlet var sexSegment: UISegmentedControl!
    @IBOutlet var peopleSegment: UISegmentedControl!
    @IBOutlet var lessonHopeTextView: PlaceHolderTextView!
    @IBOutlet var lessonLocationLabel: UILabel!
    @IBOutlet var lessonLocationButton: UIButton!
    @IBOutlet var lessonCustomDateTextField: UITextField!
    @IBOutlet var lessonStartDateButton: [UIButton]!
    @IBOutlet var menteeAgeTextField: UITextField!
    @IBOutlet var lessonTimeButton: [UIButton]!
    @IBOutlet var lessonDayButton: [UIButton]!
    @IBOutlet var lessonSkillTextView: PlaceHolderTextView!
    @IBOutlet var lessonAimTextView: PlaceHolderTextView!
    @IBOutlet var lessonFormTextView: PlaceHolderTextView!
    
    var request:Request?
    var requestPopUp = ""
    
    let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
    
    var selectedUser:User? {
        didSet {
            configureUser()
        }
    }
    
    var people = "개인 레슨"
    var sex = "남"
    var day = ""
    var time = ""
    var customDay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponent()
        
        if requestPopUp == "PopUp" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send Estimate", style: .plain, target: self, action: #selector(sendEstimate))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendRequest))
        }
    }
    
    @objc func sendEstimate() {
        let contractStoryBoard = UIStoryboard(name: "Contract", bundle: nil)
        let sendEstimateVC = contractStoryBoard.instantiateViewController(withIdentifier: "sendEstimateVC") as! SendEstimateController
        sendEstimateVC.selectedUser = selectedUser
        sendEstimateVC.fromCheck = "Request"
        navigationController?.pushViewController(sendEstimateVC, animated: true)
        
    }
    
    func configureUser() {
        guard let user = selectedUser else { return }
        print(user)
    }
    
    @objc func sendRequest() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        for i in 0 ..< 7{
            if selectedDayButton[i] {
                day += lessonDayButton[i].currentTitle!
            }
        }
        
        for i in 0 ..< 6{
            if selectedTimeButton[i] {
                if i == 0 {
                    time += lessonTimeButton[i].currentTitle!
                } else {
                    time += ",\(lessonTimeButton[i].currentTitle!)"
                }
            }
        }
        
        if lessonCustomDateTextField.text != nil {
            customDay += ", \(lessonCustomDateTextField.text)"
        }
        
        Database.database().sendRequestToFollow(uid: uid,
                                                withFollowId: selectedUser!.uid,
                                                kindOf: lessonFormTextView.text,
                                                aim: lessonAimTextView.text,
                                                skill: lessonSkillTextView.text,
                                                people: people,
                                                day: day,
                                                time: time,
                                                age: menteeAgeTextField.text!,
                                                sex: sex,
                                                startDate: customDay,
                                                location: lessonLocationLabel.text!,
                                                hope: lessonHopeTextView.text, completion: {(err) in
                                                    if err != nil {
                                                        return
                                                    }
        })
        
        navigationController?.popViewController(animated: true)
    }
    
    func initUserInteraction(flag: Bool) {
//        @IBOutlet var sexSegment: UISegmentedControl!
        sexSegment.isUserInteractionEnabled = flag
        
//        @IBOutlet var peopleSegment: UISegmentedControl!
        peopleSegment.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonHopeTextView: PlaceHolderTextView!
        lessonHopeTextView.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonLocationLabel: UILabel!
        
//        @IBOutlet var lessonLocationButton: UIButton!
        lessonLocationButton.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonCustomDateTextField: UITextField!
        lessonCustomDateTextField.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonStartDateButton: [UIButton]!
        lessonStartDateButton.forEach( {(btn) in
            btn.isUserInteractionEnabled = flag
        })
        
//        @IBOutlet var menteeAgeTextField: UITextField!
        menteeAgeTextField.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonTimeButton: [UIButton]!
        lessonTimeButton.forEach({(btn) in
            btn.isUserInteractionEnabled = flag
        })
        
//        @IBOutlet var lessonDayButton: [UIButton]!
        lessonDayButton.forEach({(btn) in
            btn.isUserInteractionEnabled = flag
        })

//        @IBOutlet var lessonSkillTextView: PlaceHolderTextView!
        lessonSkillTextView.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonAimTextView: PlaceHolderTextView!
        lessonAimTextView.isUserInteractionEnabled = flag
        
//        @IBOutlet var lessonFormTextView: PlaceHolderTextView!
        lessonFormTextView.isUserInteractionEnabled = flag
    }
    
    func initComponent() {
        
        var flag: Bool = true
        
        
        //Custom TextView
        
        lessonFormTextView.setBorder(width: 0.5, color: myColor, corner: 5)
        
        lessonAimTextView.setBorder(width: 0.5, color: myColor, corner: 5)
        
        lessonSkillTextView.setBorder(width: 0.5, color: myColor, corner: 5)
        
        lessonHopeTextView.setBorder(width: 0.5, color: myColor, corner: 5)
        
        if requestPopUp == "PopUp" {
            initUserInteraction(flag: !flag)
//            kindOf: Optional("흥행"),
            lessonFormTextView.text = request?.kindOf
//            aim: Optional("흥행"),
            lessonAimTextView.text = request?.aim
//            skill: Optional("ㅎㅇㅎㅇ"),
            lessonSkillTextView.text = request?.skill
//            people: Optional("개인 레슨"),
            for i in 0 ..< 2 {
                if peopleSegment.titleForSegment(at: i) == request?.people {
                    peopleSegment.selectedSegmentIndex = i
                }
            }
//            day: Optional("월수금"),
            if let str = request?.day {
                for index in str.indices {
                    for btn in lessonDayButton {
                        if btn.currentTitle == String(str[index]) {
                            btn.isSelected = true
                            btn.backgroundColor = myColor
                            btn.layer.cornerRadius = 3
                        }
                    }
                }
            }
//            time: Optional("저녁"),
            if let str = request?.time {
                if str.contains(",") {
                    let strArr = str.components(separatedBy: ",")
                    for index in 0 ..< strArr.count {
                        for btn in lessonTimeButton {
                            if btn.currentTitle == strArr[index] {
                                btn.isSelected = true
                                btn.backgroundColor = myColor
                                btn.layer.cornerRadius = 3
                            }
                        }
                    }
                } else {
                    for btn in lessonTimeButton {
                        if btn.currentTitle == str {
                            btn.isSelected = true
                            btn.backgroundColor = myColor
                            btn.layer.cornerRadius = 3
                        }
                    }
                }
            }
//            age: Optional("21"),
            menteeAgeTextField.text = request?.age
//            sex: Optional("남"),
            for i in 0 ..< 2 {
                if sexSegment.titleForSegment(at: i) == request?.sex {
                    sexSegment.selectedSegmentIndex = i
                }
            }
//            startDate: Optional("원하는 시작 날짜가 있어요, 2월 21일"),
            if let str = request?.startDate {
                if str.contains(",") {
                    let strArr = str.components(separatedBy: ",")
                    lessonStartDateButton[2].isSelected = true
                    lessonStartDateButton[2].backgroundColor = myColor
                    lessonStartDateButton[2].layer.cornerRadius = 3
                    lessonCustomDateTextField.text = strArr[1]
                    lessonCustomDateTextField.isHidden = false
                } else {
                    for btn in lessonStartDateButton {
                        if btn.currentTitle == str {
                            btn.isSelected = true
                            btn.backgroundColor = myColor
                            btn.layer.cornerRadius = 3
                        }
                    }
                    lessonCustomDateTextField.isHidden = true
                }
            }
//            location: Optional("서울-서울 전체"),
            if let location = request?.location {
                lessonLocationLabel.text = location
            }
            lessonLocationButton.isSelected = true
            lessonLocationButton.backgroundColor = myColor
            lessonLocationButton.layer.cornerRadius = 3
//            hope: Optional("ㅎㅇㅎㅇ")))
            if let hope = request?.hope {
                lessonHopeTextView.text = hope
            }
        } else {
            initUserInteraction(flag: flag)
            lessonFormTextView.placeholderLabel.text = "ex) 외국어 - 영어\n회화, 듣기, 쓰기, 독해, 문법&어휘, 비즈니스 등"
            lessonAimTextView.placeholderLabel.text = "ex) 취업 준비, 업무능력 향상, 유학/이민 등"
            lessonSkillTextView.placeholderLabel.text = "ex) 초급, 중급, 고급\n자세하게 쓰시면 멘토에게 도움이 됩니다."
            lessonHopeTextView.placeholderLabel.text = "멘토에게 바라는 점.."
            lessonLocationLabel.text = ""
            lessonCustomDateTextField.isHidden = true
        }
        
    }
    
    @IBAction func lessonGroupPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            people = sender.titleForSegment(at: 0)!
        } else {
            people = sender.titleForSegment(at: 1)!
        }
    }
    @IBAction func menteeSexPressed(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            sex = sender.titleForSegment(at: 0)!
        } else {
            sex = sender.titleForSegment(at: 1)!
        }
    }
    
    var selectedDayButton:[Bool] = [Bool](repeating: false, count: 7)
    @IBAction func lessonDayPressed(_ sender: UIButton) {
        for idx in 0 ..< 7 {
            if sender == lessonDayButton[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    lessonDayButton[idx].backgroundColor = myColor
                    lessonDayButton[idx].layer.cornerRadius = 3
                    selectedDayButton[idx] = true
                } else {
                    lessonDayButton[idx].backgroundColor = UIColor.white
                    selectedDayButton[idx] = false
                }
            }
        }
    }
    var selectedTimeButton:[Bool] = [Bool](repeating: false, count: 6)
    @IBAction func lessonTimePressed(_ sender: UIButton) {
        for idx in 0 ..< 6 {
            if sender == lessonTimeButton[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    lessonTimeButton[idx].backgroundColor = myColor
                    lessonTimeButton[idx].layer.cornerRadius = 3
                    selectedTimeButton[idx] = true
                } else {
                    lessonTimeButton[idx].backgroundColor = UIColor.white
                    selectedTimeButton[idx] = false
                }
            }
        }
    }
    
    @IBAction func lessonStartPressed(_ sender:UIButton) {
        allDeselected()
        selectButton(button: sender)
    }
    
    func allDeselected(){
        for button in lessonStartDateButton {
            button.backgroundColor = UIColor.white
            button.setTitleColor(myColor, for: .normal)
        }
    }
    
    func selectButton(button:UIButton){
        button.backgroundColor = myColor
        button.setTitleColor(UIColor.white, for: .normal)
        if button == lessonStartDateButton[2] {
            lessonCustomDateTextField.isHidden = false
        } else {
            lessonCustomDateTextField.isHidden = true
        }
        customDay = button.currentTitle!
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let locationVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorSecond") as! CityController
        locationVC.requestVC = self
        locationVC.visitedWhatScreen = "request"
        locationVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(popView(_:)))
        
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func popView(_: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
}
