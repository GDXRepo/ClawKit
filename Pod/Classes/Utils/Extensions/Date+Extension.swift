//
//  Date+Extension.swift
//  ClawKit
//
//  Created by Georgiy Malyukov on 14.06.2018.
//  Copyright © 2018 Georgiy Malyukov. All rights reserved.
//

import Foundation

public extension Date {
    
    public var dateOnly: Date {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.day, .month, .year], from: self)
        return calendar.date(from: comps)!
    }
    public var dayBeginning: Date {
        return Calendar.current.startOfDay(for: self)
    }
    public var dayEnding: Date {
        let calendar = Calendar.current
        let from = dayBeginning
        var comps = DateComponents(calendar: calendar, timeZone: TimeZone(secondsFromGMT: 0)!)
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return calendar.date(byAdding: comps, to: from)!
    }
    
}
