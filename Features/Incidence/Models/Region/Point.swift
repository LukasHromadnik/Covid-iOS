//
//  Point.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import UIKit

extension Region {
    struct Point: Codable, Hashable {
        let x: Double
        let y: Double
        
        var cgPoint: CGPoint {
            .init(x: x, y: y)
        }
    }
}

extension Array where Element == Region.Point {
    var bezierPath: UIBezierPath {
        let path = UIBezierPath()
        path.move(to: self[0].cgPoint)
        for i in 1..<count {
            path.addLine(to: self[i].cgPoint)
        }
        path.close()
        
        return path
    }
}
