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
import Introspect

struct ContentView: View {
    @EnvironmentObject
    private var dailyReportDataLoader: DailyReportDataLoader
    
    @EnvironmentObject
    private var cumulativeReportDataLoader: CumulativeReportDataLoader
    
    @EnvironmentObject
    private var incidenceDataLoader: IncidenceDataLoader
    
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
                            .padding(.horizontal)
                    }

                    SummaryView(title: "Vývoj čísla R") {
                        RView(dataLoader: cumulativeReportDataLoader)
                            .frame(height: 200)
                            .padding(.horizontal)
                    }


                    SummaryView(title: "7-denní incidence") {
                        IncidenceView(dataLoader: incidenceDataLoader)
                            .padding(.horizontal)
                    }
                        
                    Text(lastUpdateText)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal)
                }
                .padding(.top, 8)
                .navigationTitle("Covid přehledy")
            }
            .introspectScrollView {
                let refreshControl = RefreshControl {
                    await dailyReportDataLoader.refresh()
                    await cumulativeReportDataLoader.refresh()
                    
                    lastUpdate.date = Date()
                }
                $0.refreshControl = refreshControl
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
}

final class RefreshControl: UIRefreshControl {
    private let refreshAction: () async -> Void
    
    init(refresh refreshAction: @escaping () async -> Void) {
        self.refreshAction = refreshAction
        
        super.init(frame: .zero)
        
        addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func refresh() {
        Task {
            await refreshAction()
        }
    }
}
