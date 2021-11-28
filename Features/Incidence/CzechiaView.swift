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

    @State private var height: CGFloat?
    @State private var regionColors: [String: Color] = [:]

    let colors: [Color] = [
        Color(red: 252/255, green: 237/255, blue: 229/255),
        Color(red: 247/255, green: 216/255, blue: 201/255),
        Color(red: 242/255, green: 189/255, blue: 165/255),
        Color(red: 238/255, green: 159/255, blue: 130/255),
        Color(red: 234/255, green: 129/255, blue: 99/255),
        Color(red: 228/255, green: 98/255, blue: 74/255),
        Color(red: 212/255, green: 70/255, blue: 54/255),
        Color(red: 186/255, green: 49/255, blue: 42/255),
        Color(red: 157/255, green: 37/255, blue: 33/255),
        Color(red: 117/255, green: 24/255, blue: 23/255)
    ]
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(czechia.regions, id: \.self) { region in
                    RegionShape(region: region, czechiaSize: czechia.size)
                        .fill(regionColors[region.name.code] ?? .white)
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
        .onAppear(perform: compute)
    }

    private func compute() {
        let fileURL = Bundle(for: BundleLocator.self).url(forResource: "data", withExtension: "json")!
        let data = try! Data(contentsOf: fileURL)
        let decoded = try! JSONDecoder().decode([Incidence].self, from: data)
        let models = decoded.filter { $0.region != nil }

        let minIncrease = models.map { $0.incidence! }.min()!
        let maxIncrease = models.map { $0.incidence! }.max()!

        let step = Double(maxIncrease - minIncrease) / Double(colors.count - 1)

        self.regionColors = models.reduce([String: Color]()) { dict, next in
            var dict = dict
            dict[next.region!] = colors[Int((Double(next.incidence! - minIncrease) / step).rounded())]
            return dict
        }
    }
}

#if DEBUG
struct CzechiaView_Previews: PreviewProvider {
    static var previews: some View {
        CzechiaView(czechia: .mock(), selectedRegion: .constant(nil))
    }
}
#endif
