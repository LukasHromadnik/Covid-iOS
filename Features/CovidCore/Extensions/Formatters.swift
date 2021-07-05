//
//  Formatters.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public enum Formatters {
    public enum Date {
        public static let api: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter
        }()
    }
    
    public enum Number {
        public static let total: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = " "
            return formatter
        }()
        
        public static let growth: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = " "
            formatter.positivePrefix = formatter.plusSign
            return formatter
        }()
    }
}
