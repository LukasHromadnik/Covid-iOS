//
//  Incidence.swift
//  Incidence
//
//  Created by Lukáš Hromadník on 28.11.2021.
//

import Foundation

public struct Incidence: Codable {
    enum CodingKeys: String, CodingKey {
        case region = "kraj_nuts_kod"
        case incidence = "incidence_7_100000"
    }

    public let region: String?
    public let incidence: Double?
}
