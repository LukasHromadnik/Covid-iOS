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

public final class DailyReportDataLoader: ObservableObject {
    @Published public var dailyReportItems: DataState<[DailyReportItem]> = .value([])
    
    private let dataFetcher: DataFetcher<BasicReport>
    
    public init(dataFetcher: DataFetcher<BasicReport>) {
        self.dataFetcher = dataFetcher
        
        refresh()
    }
    
    public func refresh(completion: (() -> Void)? = nil) {
        dailyReportItems = .loading
        
        dataFetcher.load { [weak self] in
            guard let report = $0?.first else { return }
            self?.processReport(report)
            self?.saveReport(report)
            completion?()
        }
    }
    
    private func processReport(_ report: BasicReport) {
        localDataFetcher(resource: report.yesterdayDate)
            .load { [weak self] (response: [BasicReport]?) in
                if let oldReport = response?.first {
                    self?.updateDailyReport(old: oldReport, new: report)
                } else {
                    userDefaultsDataFetcher(key: report.yesterdayDate)
                        .load { [weak self] (response: [BasicReport]?) in
                            guard let oldReport = response?.first else {
                                self?.dailyReportItems = .error
                                return
                            }
                            self?.updateDailyReport(old: oldReport, new: report)
                        }
                }
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
