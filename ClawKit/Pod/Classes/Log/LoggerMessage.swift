//
//  LoggerMessage.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 08.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public enum LogLevel: Int {
    case debug = 0
    case info
    case warning
    case error
}

open class LoggerMessage {
    
    public let function: String
    public let date: Date
    public let level: LogLevel
    public let message: String
    
    public init(date: Date, function: String, level: LogLevel, message: String) {
        self.date = date
        self.function = function
        self.level = level
        self.message = message
    }
    
}
