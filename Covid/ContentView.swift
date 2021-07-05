//
//  ContentView.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import CovidCore
import SwiftUI
import Bars
import NumberR

struct ContentView: View {
    @ObservedObject var dataLoader = CumulativeReportDataLoader(
        dataFetcher: networkDataFetcher(url: DataSource.nakaza),
        dateProvider: .live
    )
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    SummaryView(title: "Denní přehled") {
                        DailyReportView(
                            dataLoader: DailyReportDataLoader(
                                dataFetcher: networkDataFetcher(url: DataSource.basicReport)
                            )
                        )
                    }
                    
                    SummaryView(title: "Srovnání denních přírůstků covidu s minulým a předminulým týdnem v ČR") {
                        BarsView(dataLoader: dataLoader)
                    }
                    
                    SummaryView(title: "Vývoj čísla R") {
                        RView(dataLoader: dataLoader)
                            .frame(height: 200)
                    }
                }
                .padding()
                .navigationTitle("Covid přehledy")
                .navigationBarItems(
                    trailing: Button(
                        action: refresh,
                        label: { Image(systemName: "arrow.clockwise") }
                    )
                )
            }
        }
    }
    
    private func refresh() {
        dataLoader.refresh()
    }
}
