//
//  DateManager.swift
//  Crypto Tycoon
//
//  Created by Ethan Barker on 12/21/17.
//  Copyright © 2017 Ethan Barker. All rights reserved.
//

import Foundation

class DateManager {
    
    public enum Dates {
        case now
        case yesterday
        case lastWeek
        case lastMonth
        case lastYear
    }
    
    public static func getDate(from time: Dates) -> Date {
        let now = Date(timeIntervalSinceNow: 0) // Use as a reference for all other time frames
        switch time {
        case .now:
            return now
        case .yesterday:
            return Calendar.current.date(byAdding: .day, value: -1, to: now)!
        case .lastWeek:
            return Calendar.current.date(byAdding: .day, value: -7, to: now)!
        case .lastMonth:
            return Calendar.current.date(byAdding: .month, value: -1, to: now)!
        case .lastYear:
            return Calendar.current.date(byAdding: .year, value: -1, to: now)!
        }
    }
    
}
