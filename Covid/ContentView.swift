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
import DailyReport

struct ContentView: View {
    @EnvironmentObject
    private var dailyReportDataLoader: DailyReportDataLoader
    
    @EnvironmentObject
    private var cumulativeReportDataLoader: CumulativeReportDataLoader
    
    @EnvironmentObject
    private var lastUpdate: LastUpdate
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    SummaryView(title: "Denní přehled") {
                        DailyReportView(dataLoader: dailyReportDataLoader)
                    }
                    
                    SummaryView(title: "Srovnání denních přírůstků covidu s minulým a předminulým týdnem v ČR") {
                        BarsView(dataLoader: cumulativeReportDataLoader)
                    }
                    
                    SummaryView(title: "Vývoj čísla R") {
                        RView(dataLoader: cumulativeReportDataLoader)
                            .frame(height: 200)
                    }
                    
                    HStack {
                        Spacer()
                        
                        Text(lastUpdateText)
                            .font(.caption)
                            .foregroundColor(.gray)
                     
                        Spacer()
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
    
    private var lastUpdateText: String {
        if let date = lastUpdate.date {
            let formatted = Formatters.Date.dateTime.string(from: date)
            return "Naposledy aktualizováno \(formatted)"
        } else {
            return "Nikdy neaktualizováno"
        }
    }
    
    private func refresh() {
        dailyReportDataLoader.refresh()
        cumulativeReportDataLoader.refresh()
        
        lastUpdate.date = Date()
    }
}
