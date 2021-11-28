//
//  IncidenceView.swift
//  Czechia
//
//  Created by Lukáš Hromadník on 09.03.2021.
//

import SwiftUI

public struct IncidenceView: View {
    private let czechia: Czechia

    @State var selectedRegion: Region?

    public init() {
        let filePath = Bundle(for: BundleLocator.self).path(forResource: "regions", ofType: "json")!
        let fileData = try! Data(contentsOf: URL(fileURLWithPath: filePath))
        czechia = try! JSONDecoder().decode(Czechia.self, from: fileData)
    }
    
    public var body: some View {
        CzechiaView(czechia: czechia, selectedRegion: $selectedRegion)
            .padding()
    }
}

struct IncidenceView_Previews: PreviewProvider {
    static var previews: some View {
        IncidenceView()
    }
}
