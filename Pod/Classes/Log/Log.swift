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
    
    private func log(_ message: String, to id: String, level: LogLevel = .debug) {
        guard let logger = Log.shared[id] else {
            assertionFailure("Unknown identifier")
            return
        }
        let calledBy = Thread.callStackSymbols[2]
        let stackInfo = CallStackParser.classAndMethodForStackSymbol(calledBy)
        logger.log(message, level: level, callStackInfo: stackInfo)
    }
    
    public static func d(_ message: String, to id: String) {
        shared.log(message, to: id, level: .debug)
    }
    
    public static func i(_ message: String, to id: String) {
        shared.log(message, to: id, level: .info)
    }
    
    public static func w(_ message: String, to id: String) {
        shared.log(message, to: id, level: .warning)
    }
    
    public static func e(_ message: String, to id: String) {
        shared.log(message, to: id, level: .error)
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
        let calledBy = Thread.callStackSymbols[2]
        let stack = CallStackParser.classAndMethodForStackSymbol(calledBy)
        let fm = FileManager.default
        // check whether the path is a directory
        var isDir: ObjCBool = false
        if fm.fileExists(atPath: path, isDirectory: &isDir) && isDir.boolValue {
            e("Log flush failed: File is expected but directory was found. Path: \(path)", to: loggerId)
            return false
        }
        if !fm.isWritableFile(atPath: path) {
            e("Log flush failed: Specified path has no \"write\" access. Path: \(path)", to: loggerId)
            return false
        }
        guard let handle = FileHandle(forWritingAtPath: path) else {
            e("Log flush failed: Unable to open writing file handle. Path \(path)", to: loggerId)
            return false
        }
        i("Initiated flushing to file at path: \(path)", to: loggerId)
        logger.messages.forEach { msg in
            var text = logger.string(from: msg, callStackInfo: stack)
            if !text.hasSuffix("\n") {
                text.append("\n")
            }
            handle.write(text.data(using: .utf8)!)
        }
        handle.closeFile()
        logger.clear()
        i("Successfully flushed to file at path: \(path)", to: loggerId)
        return true
    }
    
}
