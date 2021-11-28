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
import Incidence

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

                    SummaryView(title: "7-denní incidence") {
                        IncidenceView()
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
                    trailing: Button {
                        Task { await refresh() }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
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
    
    private func refresh() async {
        await dailyReportDataLoader.refresh()
        await cumulativeReportDataLoader.refresh()
        
        lastUpdate.date = Date()
    }
}
