//
//  Region.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import Foundation

struct Region: Codable, Hashable {
    let name: Variant
    let points: [Point]
}
