//
//  RegionShape.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import SwiftUI
import UIKit

struct RegionShape: Shape {
    let region: Region
    let czechiaSize: CGSize
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        path.move(to: region.points[0].cgPoint)
        for i in 1..<region.points.count {
            path.addLine(to: region.points[i].cgPoint)
        }
        path.close()
        path.apply(transformation(for: rect.width))

        return Path(path.cgPath)
    }
    
    private func transformation(for width: CGFloat) -> CGAffineTransform {
        let widthFactor = width / czechiaSize.width
        let heightFactor = (czechiaSize.height / czechiaSize.width * width) / czechiaSize.height
        
        return CGAffineTransform(scaleX: widthFactor, y: heightFactor)
    }
}
