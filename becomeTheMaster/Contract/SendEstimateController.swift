//
//  SendEstimateController.swift
//  portfolioTabBar
//
//  Created by Loho on 01/09/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

//#98B8DB
//#7394B9
//#4F6C9A
//#405888

import UIKit
import DropDown
import Firebase

class SendEstimateController: UIViewController {
    @IBOutlet var mentorMessageTextField: UITextField!
    @IBOutlet var confirmButton: UIButton!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var dropDownButton: UIButton!
    
    var selectedUser: User?
    
    var dropDown = DropDown()
    
    var fromCheck = ""
    
    var estimate:Estimate?
    var estimatePopUp = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if fromCheck == "Request" {
            confirmButton.isHidden = true
        } else {
            confirmButton.isHidden = false
            self.navigationItem.rightBarButtonItem?.title = ""
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(sendEstimate))
        
        // Do any additional setup after loading the view.
        
        initComponent()
        
    }
    
    func initComponent() {
        //DropDownButton
        dropDown.anchorView = dropDownButton
        dropDown.bottomOffset = CGPoint(x: 0, y: (dropDown.anchorView?.plainView.bounds.height)!)
        dropDownButton.layer.cornerRadius = 5
        dropDown.dataSource = ["30분 당","1시간 당","총 비용"]
        dropDown.backgroundColor = UIColor.colorWithRGBHex(hex: 0x98B8DB)
        
        
        dropDownButton.addTarget(self, action: #selector(dropDownButtonPressed), for: .touchUpInside)
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.dropDownButton.setTitle("\(item) ", for: .normal)
        }
        
        //Confirm & Pay Button
        if let img = applyNavGradient(colours: [ UIColor.colorWithHexString(hexStr: "#405888"), UIColor.colorWithHexString(hexStr: "#98B8DB")]) {
//            header.contentView.backgroundColor = UIColor(patternImage: img)
            confirmButton.backgroundColor = UIColor(patternImage: img)
        }
        
        if estimatePopUp == "PopUp" {
            dropDownButton.setTitle(estimate?.timePerMoney, for: .normal)
            dropDownButton.isUserInteractionEnabled = false
            
            priceTextField.text = estimate?.price
            priceTextField.isUserInteractionEnabled = false
            
            mentorMessageTextField.text = estimate?.text
            mentorMessageTextField.isUserInteractionEnabled = false
        }
    }
    
    @objc func sendEstimate() {
        let timePerMoney = dropDownButton.currentTitle ?? ""
        print(timePerMoney)
        let price = priceTextField.text ?? ""
        print(price)
        let text = mentorMessageTextField.text ?? ""
        print(text)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print(uid)
        guard let followUid = selectedUser?.uid else {return}
        print(followUid)
        Database.database().sendEstimateToFollow(uid: uid, withFollowId: followUid, moneyPerTime: timePerMoney, price: price, text: text, completion: { (err) in
            if err != nil {
                print(err)
            }
            print("Success")
        })
        var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
        navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
        self.navigationController?.viewControllers = navigationArray!
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Matching Success", message:
            "결제가 완료되었습니다.\n멘토와 이야기 하세요.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func dropDownButtonPressed() {
        dropDown.show()
    }

}
