//
//  Case.swift
//  BarChart
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation
//"datum": "2020-01-29",
//"pocetDen": 0,
//"pocetCelkem": 0

protocol CoronaEntry: Codable {
    var date: Date { get }
    var totalDay: Int { get }
    var total: Int { get }
}

struct Case: CoronaEntry {
    let date: Date
    let totalDay: Int
    let total: Int
}

extension Case {
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case totalDay = "pocetDen"
        case total = "pocetCelkem"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = formatter.date(from: dateString)!

        self.totalDay = try container.decode(Int.self, forKey: .totalDay)
        self.total = try container.decode(Int.self, forKey: .total)
    }
}
