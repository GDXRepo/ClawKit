//
//  Logger.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 08.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public class Logger {
    
    public let id: String
    public let creationDate = Date()
    public var enabled = true
    public var consoleOutput = true
    public var level: LogLevel
    public private(set) var messages = [LoggerMessage]()
    private let df = DateFormatter()
    
    public init(id: String = UUID().uuidString, level: LogLevel = .debug, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        assert(!id.isEmpty, "Invalid identifier.")
        self.id = id
        self.level = level
        df.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSSZ"
        df.timeZone = timeZone
    }
    
}

// MARK: - Logging

extension Logger {
    
    public func string(from message: LoggerMessage, function: String) -> String {
        return "\(df.string(from: message.date)) \(function) [\(id)] \(message.message)"
    }
    
    public func log(_ message: String, level: LogLevel = .debug, function: String) {
        guard enabled else { return }
        guard level.rawValue >= self.level.rawValue else { return }
        let msg = LoggerMessage(date: Date(), function: function, level: level, message: message)
        messages.append(msg)
        if consoleOutput {
            let value = string(from: msg, function: function)
            Dispatch.medium.async {
                print(value)
            }
        }
    }
    
    public func debug(_ message: String, function: String) {
        log(message, function: function)
    }
    
    public func info(_ message: String, function: String) {
        log(message, level: .info, function: function)
    }
    
    public func warn(_ message: String, function: String) {
        log(message, level: .warning, function: function)
    }
    
    public func error(_ message: String, function: String) {
        log(message, level: .error, function: function)
    }
    
    public func clear() {
        messages.removeAll()
    }
    
}
