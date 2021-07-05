//
//  DailyReport.swift
//  Covid
//
//  Created by Lukáš Hromadník on 27.04.2021.
//

import Foundation

public struct DailyReport {
    public struct Difference: Hashable {
        public let growth: Int
        public let total: Int
    }

    public let confirmedCases: Difference
    public let activeCases: Difference
    public let cured: Difference
    public let hospitalized: Difference
    public let deaths: Difference
    public let vaccination: Difference
}

public extension DailyReport {
    init(new: BasicReport, old: BasicReport) {
        self.confirmedCases = .init(
            growth: new.confirmedCases,
            total: new.confirmedCasesTotal
        )
        self.activeCases = .init(
            growth: new.activeCasesTotal - old.activeCasesTotal,
            total: new.activeCasesTotal
        )
        self.cured = .init(
            growth: new.curedTotal - old.curedTotal,
            total: new.curedTotal
        )
        self.hospitalized = .init(
            growth: new.hospitalizedTotal - old.hospitalizedTotal,
            total: new.hospitalizedTotal
        )
        self.deaths = .init(
            growth: new.deathsTotal - old.deathsTotal,
            total: new.deathsTotal
        )
        self.vaccination = .init(
            growth: new.vaccination,
            total: new.vaccinationTotal
        )
    }
}
