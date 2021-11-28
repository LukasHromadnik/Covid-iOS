//
//  Czechia.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import UIKit

struct Czechia: Codable {
    let regions: [Region]
}

extension Czechia {
    var size: CGSize {
        let points = regions.map(\.points).reduce([], +)
        let width = points.map(\.x).max() ?? 0
        let height = points.map(\.y).max() ?? 0
        
        return CGSize(width: width, height: height)
    }
}

#if DEBUG
extension Czechia {
    static func mock(
        regions: [Region] = []
    ) -> Czechia {
        Czechia(regions: regions)
    }
}
#endif
