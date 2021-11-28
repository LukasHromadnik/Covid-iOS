//
//  Incidence.swift
//  Incidence
//
//  Created by Lukáš Hromadník on 28.11.2021.
//

import Foundation

struct Incidence: Codable {
    enum CodingKeys: String, CodingKey {
        case region = "kraj_nuts_kod"
        case incidence = "incidence_7_100000"
    }

    let region: String?
    let incidence: Double?
}
