//
//  Dispatch.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 09.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

class Dispatch {
    
    static var main: DispatchQueue {
        return DispatchQueue.main
    }
    static var highest: DispatchQueue {
        return DispatchQueue.global(qos: .userInteractive)
    }
    static var high: DispatchQueue {
        return DispatchQueue.global(qos: .userInitiated)
    }
    static var medium: DispatchQueue {
        return DispatchQueue.global(qos: .utility)
    }
    static var low: DispatchQueue {
        return DispatchQueue.global(qos: .background)
    }
    
}
