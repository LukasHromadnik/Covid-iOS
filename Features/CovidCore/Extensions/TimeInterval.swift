//
//  TimeInterval.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public extension TimeInterval {
    static func days(_ value: Int) -> TimeInterval {
        TimeInterval(value) * 86400 // 24 * 60 * 60
    }
    
    static func weeks(_ value: Int) -> TimeInterval {
        TimeInterval(value) * 604800 // 7 * 24 * 60 * 60
    }
}
