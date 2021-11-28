//
//  RegionShape.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import SwiftUI

struct RegionShape: Shape {
    let region: Region
    let czechiaSize: CGSize
    
    func path(in rect: CGRect) -> Path {
        let bezierPath = region.points.bezierPath
        bezierPath.apply(transformation(for: rect.width))
        return Path(bezierPath.cgPath)
    }
    
    private func transformation(for width: CGFloat) -> CGAffineTransform {
        let widthFactor = width / czechiaSize.width
        let heightFactor = (czechiaSize.height / czechiaSize.width * width) / czechiaSize.height
        
        return CGAffineTransform(scaleX: widthFactor, y: heightFactor)
    }
}
