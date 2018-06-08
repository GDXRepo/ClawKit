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

public class LoggerMessage {
    
    public let date: Date
    public let calledBy: (String, String)?
    public let level: LogLevel
    public let message: String
    
    public init(date: Date, calledBy: (String, String)?, level: LogLevel, message: String) {
        self.date = date
        self.calledBy = calledBy
        self.level = level
        self.message = message
    }
    
}
