//
//  Date.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public extension Date {
    /// Start of the week from monday
    func startOfWeek(using calendar: Calendar = .current) -> Date {
        var currentDate = self
        let currentDateComponents = calendar.dateComponents([.weekday], from: currentDate)
        
        guard let weekday = currentDateComponents.weekday else { assertionFailure(); return currentDate}
        
        switch weekday {
        case 1:
            currentDate.addTimeInterval(.days(-6))
        case 2:
            break // monday is the beginning
        case 3...7:
            let shift = weekday - 2
            currentDate.addTimeInterval(.days(-shift))
        default:
            assertionFailure()
            break
        }
        
        return calendar.dateComponents([.calendar, .day, .month, .year], from: currentDate).date!
    }
}
