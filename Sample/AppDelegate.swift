//
//  AppDelegate.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 20.08.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Keychain.account = "com.GDXRepo.Sample.keychainAccount"
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}

