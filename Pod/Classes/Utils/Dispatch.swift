//
//  Dispatch.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public class Dispatch {
    
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
    
}
