//
//  CzechiaHeightPreferenceKey.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import SwiftUI

struct CzechiaHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
