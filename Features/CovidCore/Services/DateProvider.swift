//
//  DateProvider.swift
//  CovidCore
//
//  Created by Lukáš Hromadník on 05.07.2021.
//

import Foundation

public struct DateProvider {
    public var date: () -> Date
}

extension DateProvider {
    public static var live: Self {
        .init(date: Date.init)
    }
    
    public static func fixed(_ date: String) -> Self {
        let date = Formatters.Date.api.date(from: date)!
        return .init(date: { date })
    }
}
