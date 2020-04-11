//
//  Test.swift
//  BarChart
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Nguyen Vu Nhat Minh. All rights reserved.
//

import Foundation

struct TestsContainer: Codable {
    let data: [Test]
}

struct Test: CoronaEntry {
    let date: Date
    let totalDay: Int
    let total: Int
}

extension Test {
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case totalDay = "testy-den"
        case total = "testy-celkem"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = formatter.date(from: dateString)!

        self.totalDay = try container.decode(Int.self, forKey: .totalDay)
        self.total = try container.decode(Int.self, forKey: .total)
    }
}
