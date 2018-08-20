//
//  Dispatch.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public final class Dispatch {
    
    public static var main: DispatchQueue {
        return DispatchQueue.main
    }
    public static var highest: DispatchQueue {
        return DispatchQueue.global(qos: .userInteractive)
    }
    public static var high: DispatchQueue {
        return DispatchQueue.global(qos: .userInitiated)
    }
    public static var medium: DispatchQueue {
        return DispatchQueue.global(qos: .utility)
    }
    public static var low: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    private static var _onceTracker = [String]()
    
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        guard !_onceTracker.contains(token) else {
            return
        }
        _onceTracker.append(token)
        block()
    }
    
}

public extension DispatchQueue {
    
    public func after(_ seconds: Double, block: @escaping () -> ()) {
        let time: DispatchTime = .now() + seconds
        asyncAfter(deadline: time, execute: block)
    }
    
}
