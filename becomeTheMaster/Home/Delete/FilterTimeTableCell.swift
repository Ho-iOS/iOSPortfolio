//
//  FilterTimeTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FilterTimeTableCell: UITableViewCell {
    @IBOutlet var timeButtons: [UIButton]!
    
    static var timeCellID = "timeCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onClicked(_ sender: UIButton) {
        for idx in 0 ..< 4 {
            if sender == timeButtons[idx] {
                sender.isSelected = !sender.isSelected
                if sender.isSelected {
                    timeButtons[idx].backgroundColor = UIColor.colorWithRGBHex(hex: 0x60C3FF)
                    timeButtons[idx].layer.cornerRadius = 3
                } else {
                    timeButtons[idx].backgroundColor = UIColor.white
                }
            }
        }
    }
    
}
