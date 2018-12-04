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

    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var window: UIWindow?
    var rootController: ViewController {
        return window!.rootViewController as! ViewController
    }
    
    private(set) var isPaused = false
    
}

extension AppDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if Cache.clear() {
            exit(0) // detect jailbroken device
        }
        Keychain.account = "com.GDXRepo.Sample.keychainAccount"
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.post("ApplicationWillPause")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        isPaused = true
        Shield.onDidEnterBackground()
        NotificationCenter.post("ApplicationDidPause")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if isPaused { // workaround: necessary for FaceID separated system controller
            NotificationCenter.post("ApplicationDidResume")
        }
        isPaused = false
        Shield.onDidBecomeActive()
        NotificationCenter.post("ApplicationDidBecomeActive")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.post("ApplicationWillTerminate")
    }

}

