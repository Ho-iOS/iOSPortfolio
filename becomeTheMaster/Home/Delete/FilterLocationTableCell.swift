//
//  LocationTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FilterLocationTableCell: UITableViewCell {
    
    @IBOutlet weak var locationLabelView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    
    
    
    static var locationCellID = "locationCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
