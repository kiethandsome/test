//
//  AppDelegate.swift
//  test
//
//  Created by Kiet on 10/11/17.
//  Copyright © 2017 Kiet. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        mainViewController()
        return true
    }
    
    func mainViewController() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainVc = MainViewController()
        
        self.window?.rootViewController = mainVc
        self.window?.makeKeyAndVisible()
    }
    
}

