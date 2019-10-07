//
//  AppDelegate.swift
//  portfolioTabBar
//
//  Created by Loho on 17/07/2019.
//  Copyright © 2019 Loho. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var globalFlag: Bool? = false
    
    var user: User?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Thread.sleep(forTimeInterval: 0.4)
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Pass device token to auth
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
}
