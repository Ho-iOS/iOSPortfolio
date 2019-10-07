//
//  FilterDayTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FilterDayTableCell: UITableViewCell {
//    @IBOutlet var dayButtons:[UIButton]!
//    
    static var dayCellID = "dayCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClicked(_ sender: UIButton) {
        for idx in 0 ..< 7 {
            if sender == dayButtons[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    dayButtons[idx].backgroundColor = UIColor.colorWithRGBHex(hex: 0x60C3FF)
                    dayButtons[idx].layer.cornerRadius = 3
                } else {
                    dayButtons[idx].backgroundColor = UIColor.white
                }
            }
        }
    }

}
