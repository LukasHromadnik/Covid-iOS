//
//  View.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import SwiftUI

public extension View {
    func inExpandingRectangle() -> some View {
        ZStack {
            Rectangle()
                .fill(Color.clear)
            self
        }
    }
}
