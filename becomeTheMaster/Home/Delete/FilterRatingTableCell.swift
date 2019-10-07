//
//  RatingTableCell.swift
//  portfolioTabBar
//
//  Created by Loho on 19/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Cosmos

class FilterRatingTableCell: UITableViewCell {
    @IBOutlet weak var ratingSlider: UISlider!
    @IBOutlet var cosmosView: CosmosView!
    
    static var ratingCellID = "ratingCellID"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func sliderValueChange(_ sender: UISlider) {
        cosmosView.rating = Double(ratingSlider.value)
    }
}
