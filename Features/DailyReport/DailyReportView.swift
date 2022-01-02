//
//  CovidBaseView.swift
//  Playground
//
//  Created by Lukáš Hromadník on 27.04.2021.
//

import SwiftUI
import CovidCore

struct DailyReportItemView: View {
    let title: String
    let value: String
    let subvalue: String
    let tintColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .foregroundColor(Color(.label))
                .font(.caption2)
            
            Text(value)
                .foregroundColor(tintColor)
                .fontWeight(.bold)
            
            Text(subvalue)
                .foregroundColor(tintColor)
                .font(.caption2)
        }
    }
}

public struct DailyReportView: View {
    @ObservedObject var dataLoader: DailyReportDataLoader
    
    public init(dataLoader: DailyReportDataLoader) {
        self.dataLoader = dataLoader
    }

    public var body: some View {
        switch dataLoader.dailyReportItems {
        case .loading:
            ProgressView()
                .padding(.horizontal)
        case .error:
            Label(
                title: { Text("Nepodařilo se načíst data") },
                icon: { Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.yellow) }
            )
                .padding(.horizontal)
        case let .value(items):
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        DailyReportItemView(
                            title: item.title,
                            value: formatGrowth(item.values.growth),
                            subvalue: formatTotal(item.values.total),
                            tintColor: item.color
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func formatGrowth(_ value: Int) -> String {
        Formatters.Number.growth.string(from: NSNumber(value: value))!
    }

    private func formatTotal(_ value: Int) -> String {
        Formatters.Number.total.string(from: NSNumber(value: value))!
    }
}

struct DailyReportView_Previews: PreviewProvider {
    static var previews: some View {
        DailyReportView(
            dataLoader: DailyReportDataLoader(
                dataFetcher: localDataFetcher(resource: "2021-04-26")
            )
        )
        .previewLayout(.sizeThatFits)
    }
}
