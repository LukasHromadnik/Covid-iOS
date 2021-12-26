//
//  IncidenceView.swift
//  Czechia
//
//  Created by Lukáš Hromadník on 09.03.2021.
//

import SwiftUI
import CovidCore

public struct IncidenceView: View {
    @State var selectedRegion: Region?

    @ObservedObject private var dataLoader: IncidenceDataLoader
    
    private let czechia: Czechia

    public init(dataLoader: IncidenceDataLoader) {
        let filePath = Bundle(for: BundleLocator.self).path(forResource: "regions", ofType: "json")!
        let fileData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        czechia = try! JSONDecoder().decode(Czechia.self, from: fileData)
        
        self.dataLoader = dataLoader
    }
    
    public var body: some View {
        CzechiaView(
            czechia: czechia,
            selectedRegion: $selectedRegion,
            regionColors: { dataLoader.regionColors[$0] }
        )
        .padding()
        .task {
            await dataLoader.refresh()
        }
    }
}

//struct IncidenceView_Previews: PreviewProvider {
//    static var previews: some View {
//        IncidenceView(dataLoader: O
//    }
//}
