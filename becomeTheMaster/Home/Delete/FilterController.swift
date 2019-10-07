//
//  FilterController.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FilterController: UITableViewController {
    
    var locationStr: String? = ""

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
//        print("Filter, \(locationStr)")
    }
    
    @objc func goToLocation(_ sender: UIGestureRecognizer) {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let locationVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorSecond") as! CityController
        locationVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(handleLocation(_:)))
        locationVC.visitedWhatScreen = "Filter"
        navigationController?.pushViewController(locationVC, animated: true)
        
    }
    
    @objc func handleLocation(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func goToField(_ sender: UIGestureRecognizer) {
        let loginStoryBoard = UIStoryboard(name: "Login", bundle: nil)
        let fieldVC = loginStoryBoard.instantiateViewController(withIdentifier: "MentorThird") as! FieldController
        fieldVC.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(handleField(_:)))
        fieldVC.visitedWhatScreen = "Filter"
        navigationController?.pushViewController(fieldVC, animated: true)
        
    }
    
    @objc func handleField(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterRatingTableCell.ratingCellID, for: indexPath) as! FilterRatingTableCell
//            cell.cosmosView.rating = Double(cell.ratingSlider.value)
            cell.cosmosView.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterLocationTableCell.locationCellID, for: indexPath) as! FilterLocationTableCell
            let locationGesture = UITapGestureRecognizer(target: self, action: #selector(goToLocation(_ :)))
            cell.locationView.addGestureRecognizer(locationGesture)
            cell.locationLabelView.layer.cornerRadius = 5
            cell.locationLabelView.layer.borderWidth = 0.3
            cell.locationLabelView.layer.borderColor = UIColor.darkGray.cgColor
            cell.locationLabel.numberOfLines = 0
            cell.locationLabel.text = appDelegate.locationFilter
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterFieldTableCell.fieldCellID, for: indexPath) as! FilterFieldTableCell
            let fieldGesture = UITapGestureRecognizer(target: self, action: #selector(goToField(_:)))
            cell.fieldView.addGestureRecognizer(fieldGesture)
            cell.fieldLabelView.layer.cornerRadius = 5
            cell.fieldLabelView.layer.borderWidth = 0.3
            cell.fieldLabelView.layer.borderColor = UIColor.darkGray.cgColor
            cell.fieldLabel.numberOfLines = 0
            cell.fieldLabel.text = appDelegate.fieldFilter
            cell.selectionStyle = .none
            return cell
            
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterDayTableCell.dayCellID, for: indexPath) as! FilterDayTableCell
            cell.selectionStyle = .none
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: FilterTimeTableCell.timeCellID, for: indexPath) as! FilterTimeTableCell
            cell.selectionStyle = .none
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 90
        } else if indexPath.row == 1 {
            return 160
        } else if indexPath.row == 2 {
            return 160
        } else if indexPath.row == 3 {
            return 100
        } else if indexPath.row == 4{
            return 100
        } else {
            return 100
        }
    }
}
