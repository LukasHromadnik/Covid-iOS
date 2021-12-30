//
//  SummaryView.swift
//  Covid
//
//  Created by Lukáš Hromadník on 04.07.2021.
//

import SwiftUI

struct SummaryView<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            content()
        }
    }
}
