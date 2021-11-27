//
//  DataFetcher.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation
import CodableCSV

public struct DataFetcher<Value: Codable> {
    let load: () async -> [Value]?
}

public func networkDataFetcher<Value: Codable>(
    url: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher {
        let url = URL(string: url)!
        
        guard let data = try? await URLSession.shared.data(from: url).0 else { return nil }
        let decoder = CSVDecoder { $0.headerStrategy = .firstLine }
        return try? decoder.decode([Value].self, from: data)
    }
}

public func localDataFetcher<Value: Codable>(
    resource: String,
    extension ext: String = "json",
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher {
        let response = Bundle.main
            .url(forResource: resource, withExtension: ext)
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        return response?.data
    }
}

public func emptyDataFetcher<Value: Codable>(
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher<Value> { [] }
}

public func userDefaultsDataFetcher<Value: Codable>(
    key: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher {
        let response = UserDefaults.standard
            .data(forKey: key)
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        return response?.data
    }
}
