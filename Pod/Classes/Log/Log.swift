//
//  Log.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 08.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public class Log {
    
    public static let shared = Log()
    private(set) var loggers = [Logger]()
    
    private init() {
        // empty
    }
    
}

// MARK: - Management

extension Log {
    
    public subscript(name: String) -> Logger? {
        return loggers.first { $0.id == name }
    }
    
    public static func register(id: String, level: LogLevel = .debug, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        if shared[id] == nil {
            shared.loggers.append(Logger(id: id, level: level, timeZone: timeZone))
        }
    }
    
}

// MARK: - Logging

extension Log {
    
    private func log(_ message: String, to id: String, level: LogLevel = .debug, function: String) {
        guard let logger = Log.shared[id] else {
            assertionFailure("Unknown identifier")
            return
        }
        logger.log(message, level: level, function: function)
    }
    
    public static func d(_ message: String, to id: String, function: String) {
        shared.log(message, to: id, level: .debug, function: function)
    }
    
    public static func i(_ message: String, to id: String, function: String) {
        shared.log(message, to: id, level: .info, function: function)
    }
    
    public static func w(_ message: String, to id: String, function: String) {
        shared.log(message, to: id, level: .warning, function: function)
    }
    
    public static func e(_ message: String, to id: String, function: String) {
        shared.log(message, to: id, level: .error, function: function)
    }
    
}

// MARK: - Utils

extension Log {
    
    @discardableResult
    public static func flush(loggerId: String, toFileAtPath path: String) -> Bool {
        guard let logger = shared[loggerId] else {
            assertionFailure("Unknown identifier")
            return false
        }
        let fm = FileManager.default
        // check whether the path is a directory
        var isDir: ObjCBool = false
        if fm.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue {
            e("Log flush failed: File is expected but directory was found. Path: \(path)", to: loggerId, function: #function)
            return false
        }
        if !fm.isWritableFile(atPath: path) {
            e("Log flush failed: Specified path has no \"write\" access. Path: \(path)", to: loggerId, function: #function)
            return false
        }
        guard let handle = FileHandle(forWritingAtPath: path) else {
            e("Log flush failed: Unable to open writing file handle. Path \(path)", to: loggerId, function: #function)
            return false
        }
        i("Initiated flushing to file at path: \(path)", to: loggerId, function: #function)
        let f = #function
        logger.messages.forEach { msg in
            var text = logger.string(from: msg, function: f)
            if !text.hasSuffix("\n") {
                text.append("\n")
            }
            handle.write(text.data(using: .utf8)!)
        }
        handle.closeFile()
        logger.clear()
        i("Successfully flushed to file at path: \(path)", to: loggerId, function: #function)
        return true
    }
    
}
