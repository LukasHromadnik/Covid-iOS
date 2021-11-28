//
//  Region.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import UIKit

struct Region: Codable, Hashable {
    struct Point: Codable, Hashable {
        let x: Double
        let y: Double

        var cgPoint: CGPoint {
            .init(x: x, y: y)
        }
    }

    let name: Variant
    let points: [Point]
}
