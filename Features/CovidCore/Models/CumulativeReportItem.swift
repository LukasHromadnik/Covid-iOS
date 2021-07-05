//
//  CumulativeReportItem.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct CumulativeReportItem {
    public let date: String
    public let total: Int
}

extension CumulativeReportItem: Codable {
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case total = "kumulativni_pocet_nakazenych"
    }
}
