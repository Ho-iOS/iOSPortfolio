//
//  FilterViewController.swift
//  portfolioTabBar
//
//  Created by Loho on 31/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Cosmos

protocol SendDataDelegate {
    func sendData(rating: Double?, location: String?, field: String?, selectedDay: [Bool], selectedTime: [Bool], filterApplyFlag: Bool)
}

class FilterViewController: UIViewController {
    @IBOutlet var timeButtons:[UIButton]!
    @IBOutlet var dayButtons:[UIButton]!
    @IBOutlet var fieldTextView: UITextView!
    @IBOutlet var locationTextView: UITextView!
    @IBOutlet var setFieldView: UIView!
    @IBOutlet var setLocationView: UIView!
    @IBOutlet var ratingStar: CosmosView!
    @IBOutlet var ratingSlider: UISlider!
    
    lazy var locationTemp: String = ""
    lazy var fieldTemp:String = ""
    lazy var selectedDay = [Bool](repeating: false, count: 7)
    lazy var selectedTime = [Bool](repeating: false, count: 6)
    var filterApplyFlag = true
    
    var delegate: SendDataDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationTextView.text = locationTemp
        fieldTextView.text = fieldTemp
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initComponent()
        
    }
    
    func initComponent() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(popView(_:)))
        self.navigationController?.navigationBar.tintColor = UIColor.colorWithRGBHex(hex: 0x405888)
        let myColor: UIColor = UIColor.colorWithRGBHex(hex: 0x405888)
        //setLocation
        let locationGesture = UITapGestureRecognizer(target: self, action: #selector(popUpLocationView(_:)))
        setLocationView.addGestureRecognizer(locationGesture)
        locationTextView.isUserInteractionEnabled = false
        locationTextView.setBorderColor(width: 0.5, color: myColor, corner: 5)
        //setField
        let fieldGesture = UITapGestureRecognizer(target: self, action: #selector(popUpFieldView(_:)))
        setFieldView.addGestureRecognizer(fieldGesture)
        fieldTextView.isUserInteractionEnabled = false
        fieldTextView.setBorderColor(width: 0.5, color: myColor, corner: 5)
    }
    
    @objc func popUpLocationView(_ sender: UIGestureRecognizer) {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let locationVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorSecond") as! CityController
        locationVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))
        locationVC.visitedWhatScreen = "Filter"
        locationVC.filterVC = self
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func popUpFieldView(_ sender: UIGestureRecognizer) {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let fieldVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorThird") as! FieldController
        fieldVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveValue(_:)))
        fieldVC.visitedWhatScreen = "Filter"
        fieldVC.filterVC = self
        navigationController?.pushViewController(fieldVC, animated: true)
    }
    
    @objc func popView(_ sender: UIBarButtonItem) {
        for i in 0 ..< selectedDay.count {
            if selectedDay[i] == true {
                filterApplyFlag = true
                break
            } else { filterApplyFlag = false }
        }
        for j in 0 ..< selectedTime.count {
            if selectedTime[j] == true {
                filterApplyFlag = true
                break
            } else { filterApplyFlag = false }
        }
        if locationTemp != "" || fieldTemp != "" {
            filterApplyFlag = true
        } else { filterApplyFlag = false }
        delegate?.sendData(rating: ratingStar.rating, location: locationTemp, field: fieldTemp, selectedDay: selectedDay, selectedTime: selectedTime, filterApplyFlag: filterApplyFlag)
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc func saveValue(_ sender: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingSliderChanged(_ sender: UISlider) {
        var value = Double(sender.value)
        if value >= 0 && value < 0.25 {
            ratingStar.rating = 0
        } else if value >= 0.25 && value < 0.75 {
            ratingStar.rating = 0.5
        } else if value >= 0.75 && value < 1.25 {
            ratingStar.rating = 1
        } else if value >= 1.25 && value < 1.75 {
            ratingStar.rating = 1.5
        } else if value >= 1.75 && value < 2.25 {
            ratingStar.rating = 2
        } else if value >= 2.25 && value < 2.75 {
            ratingStar.rating = 2.5
        } else if value >= 2.75 && value < 3.25 {
            ratingStar.rating = 3
        } else if value >= 3.25 && value < 3.75 {
            ratingStar.rating = 3.5
        } else if value >= 3.75 && value < 4.25 {
            ratingStar.rating = 4
        }else if value >= 4.25 && value < 4.75 {
            ratingStar.rating = 4.5
        } else if value >= 4.75 {
            ratingStar.rating = 5
        }
    }
    
    @IBAction func dayButtonsPressed(_ sender: UIButton) {
        for idx in 0 ..< 7 {
            if sender == dayButtons[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    dayButtons[idx].backgroundColor = UIColor.colorWithRGBHex(hex: 0x98B8DB)
                    dayButtons[idx].layer.cornerRadius = 3
                    selectedDay[idx] = true
                } else {
                    dayButtons[idx].backgroundColor = UIColor.white
                    selectedDay[idx] = false
                }
            }
        }
    }
    
    @IBAction func timeButtonsPressed(_ sender: UIButton) {
        for idx in 0 ..< 6 {
            if sender == timeButtons[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    timeButtons[idx].backgroundColor = UIColor.colorWithRGBHex(hex: 0x98B8DB)
                    timeButtons[idx].layer.cornerRadius = 3
                    selectedTime[idx] = true
                } else {
                    timeButtons[idx].backgroundColor = UIColor.white
                    selectedTime[idx] = false
                }
            }
        }
    }

    
}
