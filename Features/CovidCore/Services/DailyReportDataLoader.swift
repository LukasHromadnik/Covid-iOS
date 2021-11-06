//
//  DailyReportDataLoader.swift
//  Covid
//
//  Created by Lukáš Hromadník on 27.04.2021.
//

import Foundation
import SwiftUI

public enum DataState<Value> {
    case value(Value)
    case loading
    case error
}

public struct DailyReportItem: Hashable {
    public let title: String
    public let values: DailyReport.Difference
    public let color: Color
}

@MainActor
public final class DailyReportDataLoader: ObservableObject {
    @Published public var dailyReportItems: DataState<[DailyReportItem]> = .value([])
    
    private let dataFetcher: DataFetcher<BasicReport>
    
    public init(dataFetcher: DataFetcher<BasicReport>) {
        self.dataFetcher = dataFetcher
        
        Task { await refresh() }
    }
    
    public func refresh(completion: (() -> Void)? = nil) async {
        dailyReportItems = .loading
        
        guard let report = await dataFetcher.load()?.first else { return }

        await processReport(report)
        saveReport(report)
    }
    
    private func processReport(_ report: BasicReport) async {
        let response: [BasicReport]? = await localDataFetcher(resource: report.yesterdayDate).load()
        
        if let oldReport = response?.first {
            updateDailyReport(old: oldReport, new: report)
        } else {
            guard let storedReport: BasicReport = await userDefaultsDataFetcher(key: report.yesterdayDate).load()?.first
            else {
                dailyReportItems = .error
                return
            }
            
            updateDailyReport(old: storedReport, new: report)
        }
    }
    
    private func saveReport(_ report: BasicReport) {
        let response = Response(data: [report])
        let data = try! JSONEncoder().encode(response)
        UserDefaults.standard.set(data, forKey: report.date)
    }
    
    private func updateDailyReport(old: BasicReport, new: BasicReport) {
        let daily = DailyReport(new: new, old: old)
        dailyReportItems = .value([
            DailyReportItem(title: "Potvrzené\npřípady", values: daily.confirmedCases, color: Color(.label)),
            DailyReportItem(title: "Aktivní\npřípady", values: daily.activeCases, color: Color(.systemRed)),
            DailyReportItem(title: "Počet\nzotavených", values: daily.cured, color: Color(.systemGreen)),
            DailyReportItem(title: "Právě\nv nemocnici", values: daily.hospitalized, color: Color(.systemBlue)),
            DailyReportItem(title: "Úmrtí\ns nákazou", values: daily.deaths, color: Color(.label)),
            DailyReportItem(title: "Vykázaná\nočkování", values: daily.vaccination, color: Color(.label))
        ])
    }
}
