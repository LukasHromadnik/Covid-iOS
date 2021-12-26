//
//  CzechiaView.swift
//  Playground
//
//  Created by Lukáš Hromadník on 14.03.2021.
//

import SwiftUI

struct CzechiaView: View {
    let czechia: Czechia
    @Binding var selectedRegion: Region?
    let regionColors: (String) -> Color?
    
    @State private var height: CGFloat?
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(czechia.regions, id: \.self) { region in
                    RegionShape(region: region, czechiaSize: czechia.size)
                        .fill(regionColors(region.name.code) ?? .white)
                        .overlay(
                            RegionShape(region: region, czechiaSize: czechia.size)
                                .stroke(lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedRegion = region
                        }
                }
                .background(
                    Color.clear.preference(
                        key: CzechiaHeightPreferenceKey.self,
                        value: czechia.size.height / czechia.size.width * proxy.size.width
                    )
                )
            }
        }
        .frame(height: height)
        .onPreferenceChange(CzechiaHeightPreferenceKey.self) {
            height = $0
        }
    }
}

#if DEBUG
struct CzechiaView_Previews: PreviewProvider {
    static var previews: some View {
        CzechiaView(czechia: .mock(), selectedRegion: .constant(nil)) { _ in .red}
    }
}
#endif
