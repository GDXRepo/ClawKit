//
//  Profiler.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 11.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public class Profiler {
    
    public let id: String
    public var elapsedSec: Double {
        let elapsedMTU = Double(mach_absolute_time() - startTime)
        if timebaseInfo.denom == 0 {
            mach_timebase_info(&timebaseInfo)
        }
        let elapsedNsec = elapsedMTU * Double(timebaseInfo.numer) / Double(timebaseInfo.denom)
        return elapsedNsec / 1_000_000_000
    }
    public var elapsedString: String {
        let elapsed = elapsedSec
        return String(format: "%.5f", elapsed)
    }
    private let logger: Logger
    private var startTime = mach_absolute_time()
    private var timebaseInfo = mach_timebase_info_data_t(numer: 0, denom: 0)
    
    public init(id: String = UUID().uuidString) {
        assert(!id.isEmpty, "Invalid profiler ID.")
        self.id = id
        logger = Logger(id: id, level: .debug, timeZone: TimeZone(secondsFromGMT: 0)!)
        logger.debug("Profiler started.")
    }
    
    public func point(message: String? = nil) {
        let string = elapsedString
        if var msg = message?.trimmed() {
            if !msg.hasSuffix(".") {
                msg.append(".")
            }
            logger.debug("\(msg) Total time \(string) sec.")
        } else {
            logger.debug("Profiler point \(string) sec.")
        }
    }
    
}
