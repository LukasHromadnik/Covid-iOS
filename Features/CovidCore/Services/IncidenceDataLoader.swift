//
//  IncidenceDataLoader.swift
//  CovidCore
//
//  Created by Lukáš Hromadník on 26.12.2021.
//

import Foundation
import SwiftUI

@MainActor
public final class IncidenceDataLoader: ObservableObject {
    @Published public var regionColors: [String: Color] = [:]
    
    private let colors: [Color] = [
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
    
    private let dataFetcher: DataFetcher<Incidence>
    
    public init(dataFetcher: DataFetcher<Incidence>) {
        self.dataFetcher = dataFetcher
        
        Task { await refresh() }
    }
    
    public func refresh(completion: (() -> Void)? = nil) async {
        // The response uses paging.
        // At first we need to download the initial request
        // where the number of all items available is provided.
        guard let response = await dataFetcher.load() else { return }
        
        let totalItems = Double(response.totalItems)
        let numberOfItems = Double(response.data.count)
        
        // Then we need to compute the number of pages
        let numberOfPages = Int(ceil(totalItems / numberOfItems))
        
        // Download the penultimate one and the last one.
        // Once new page is created we would download only the one item
        // on the last page.
        async let penultimatePage = dataFetcher.load([URLQueryItem(name: "page", value: String(numberOfPages - 1))])
        async let lastPage = dataFetcher.load([URLQueryItem(name: "page", value: String(numberOfPages))])
        
        // Run the download asynchronously and wait for the results
        let pages = await [penultimatePage, lastPage]
        
        // Combine the downloaded items
        let items = pages.compactMap { $0?.data }.flatMap { $0 }.filter { $0.region != nil }
        
        processItems(items)
    }
    
    private func processItems(_ items: [Incidence]) {
        let minIncrease = items.map { $0.incidence! }.min()!
        let maxIncrease = items.map { $0.incidence! }.max()!

        let step = Double(maxIncrease - minIncrease) / Double(colors.count - 1)

        self.regionColors = items.reduce([String: Color]()) { dict, next in
            var dict = dict
            dict[next.region!] = colors[Int((Double(next.incidence! - minIncrease) / step).rounded())]
            return dict
        }
    }
}
