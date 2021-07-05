//
//  BasicReport.swift
//  Covid
//
//  Created by Lukáš Hromadník on 27.04.2021.
//

import Foundation

public struct BasicReport {
    public let date: String
    public let yesterdayDate: String
    public let vaccinationTotal: Int
    public let vaccination: Int
    public let confirmedCasesTotal: Int
    public let confirmedCases: Int
    public let activeCasesTotal: Int
    public let curedTotal: Int
    public let deathsTotal: Int
    public let hospitalizedTotal: Int
}

extension BasicReport: Codable {
    enum CodingKeys: String, CodingKey {
        case date = "datum"
        case yesterdayDate = "vykazana_ockovani_vcerejsi_den_datum"
        case vaccinationTotal = "vykazana_ockovani_celkem"
        case vaccination = "vykazana_ockovani_vcerejsi_den"
        case confirmedCasesTotal = "potvrzene_pripady_celkem"
        case confirmedCases = "potvrzene_pripady_vcerejsi_den"
        case activeCasesTotal = "aktivni_pripady"
        case curedTotal = "vyleceni"
        case deathsTotal = "umrti"
        case hospitalizedTotal = "aktualne_hospitalizovani"
    }
}
