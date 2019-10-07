//
//  SelectedMentorAbout.swift
//  portfolioTabBar
//
//  Created by Loho on 12/08/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit

class SelectedMentorAbout: UIViewController {
    @IBOutlet var profileAboutTextView: UITextView?
    
    var uesr: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        profileAboutTextView?.text = appDelegate.user?.about

        // Do any additional setup after loading the view.
//        let filePath = Bundle.main.path(forResource: "LongText", ofType: "txt")
//        profileAboutTextView.text = try! String(contentsOfFile: filePath!, encoding: .utf8)
    }

    
}
