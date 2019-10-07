//
//  CareerTable.swift
//  portfolioTabBar
//
//  Created by Loho on 26/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class CareerTable: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "") as! MediaCell
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "") as! LicenseCell
            
            return cell
        }
    }
    

}
