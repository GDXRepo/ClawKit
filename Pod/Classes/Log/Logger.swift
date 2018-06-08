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
    
    public func string(from message: LoggerMessage, callStackInfo: (String, String)?) -> String {
        if let info = callStackInfo {
            let classname = info.0
            let method = info.1
            return "\(df.string(from: message.date)) \(classname).\(method) [\(id)] \(message.message)"
        }
        return "\(df.string(from: message.date)) [\(id)] \(message.message)"
    }
    
    public func log(_ message: String, level: LogLevel = .debug, callStackInfo: (String, String)? = nil) {
        guard enabled else { return }
        guard level.rawValue >= self.level.rawValue else { return }
        let msg = LoggerMessage(date: Date(), calledBy: callStackInfo, level: level, message: message)
        messages.append(msg)
        if consoleOutput {
            print(string(from: msg, callStackInfo: callStackInfo))
        }
    }
    
    public func debug(_ message: String, callStackInfo: (String, String)? = nil) {
        log(message, callStackInfo: callStackInfo)
    }
    
    public func info(_ message: String, callStackInfo: (String, String)? = nil) {
        log(message, level: .info, callStackInfo: callStackInfo)
    }
    
    public func warn(_ message: String, callStackInfo: (String, String)? = nil) {
        log(message, level: .warning, callStackInfo: callStackInfo)
    }
    
    public func error(_ message: String, callStackInfo: (String, String)? = nil) {
        log(message, level: .error, callStackInfo: callStackInfo)
    }
    
    public func clear() {
        messages.removeAll()
    }
    
}
