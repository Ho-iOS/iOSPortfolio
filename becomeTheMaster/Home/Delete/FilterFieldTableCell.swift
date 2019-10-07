//
//  FieldTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class FilterFieldTableCell: UITableViewCell {
    
    @IBOutlet weak var fieldLabelView: UIView!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet var fieldView: UIView!
    
    static var fieldCellID = "fieldCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
