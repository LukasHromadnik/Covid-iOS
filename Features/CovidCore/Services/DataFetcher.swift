//
//  DataFetcher.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct DataFetcher<Value: Codable> {
    let load: (_ queryItems: [URLQueryItem]) async -> Response<[Value]>?
}

public extension DataFetcher {
    func load() async -> Response<[Value]>? {
        await load([])
    }
}

public func networkDataFetcher<Value: Codable>(
    url: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { items in
        var urlComponents = URLComponents(string: url)!
        urlComponents.queryItems?.append(contentsOf: items)
        let url = urlComponents.url!
        
        guard let data = try? await URLSession.shared.data(from: url).0 else { return nil }
        
        print("[URL]", url.absoluteString)
        print("[BODY]", data.prettyPrintedJSON)
        
        return try! JSONDecoder().decode(Response<[Value]>.self, from: data)
    }
}

public func localDataFetcher<Value: Codable>(
    resource: String,
    extension ext: String = "json",
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { _ in
        let response = Bundle.main
            .url(forResource: resource, withExtension: ext)
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        return response
    }
}

public func emptyDataFetcher<Value: Codable>(
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher<Value> { _ in .data([]) }
}

public func userDefaultsDataFetcher<Value: Codable>(
    key: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { _ in
        let response = UserDefaults.standard
            .data(forKey: key)
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        return response
    }
}

extension Data {
    var prettyPrintedJSON: String {
        if
            let json = try? JSONSerialization.jsonObject(with: self, options: []),
            let prettyData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        {
            return prettyString
        } else if let jsonString = String(data: self, encoding: .utf8) {
            return jsonString
        }

        return ""
    }
}
