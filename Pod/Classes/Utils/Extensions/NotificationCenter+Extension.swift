//
//  NotificationCenter+Extension.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 11.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    
    private static let kLoggerId = "Broadcast"
    
    public class func post(_ name: String) {
        Log.d("broadcasting \(name)", to: kLoggerId, function: #function)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil, userInfo: nil)
    }
    
    public class func subscribe(_ object: Any, selector: Selector, name: String) {
        NotificationCenter.default.addObserver(
            object,
            selector: selector,
            name: NSNotification.Name(rawValue: name),
            object: nil
        )
        Log.d("subscribed \(object).\(selector) to \"\(name)\"", to: kLoggerId, function: #function)
    }
    
    public class func unsubscribe(_ object: Any, name: String? = nil) {
        if let name = name {
            NotificationCenter.default.removeObserver(object, name: NSNotification.Name(rawValue: name), object: nil)
            Log.d("unsubscribed \(object) from \"\(name)\"", to: kLoggerId, function: #function)
        } else {
            NotificationCenter.default.removeObserver(object)
            Log.d("unsubscribed \(object)", to: kLoggerId, function: #function)
        }
    }
    
}
