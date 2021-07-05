//
//  DataFetcher.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct DataFetcher<Value: Codable> {
    let load: (_ completion: @escaping ([Value]?) -> Void) -> Void
}

public func networkDataFetcher<Value: Codable>(
    url: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { completion in
        let url = URL(string: url)!
        
        URLSession.shared
            .dataTaskPublisher(for: url)
            .map { try? JSONDecoder().decode(Response<[Value]>.self, from: $0.data) }
            .receive(on: DispatchQueue.main)
            .sink { completion($0?.data) }
    }
}

public func localDataFetcher<Value: Codable>(
    resource: String,
    extension ext: String = "json",
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { completion in
        let response = Bundle.main
            .url(forResource: resource, withExtension: ext)
            .flatMap { try? Data(contentsOf: $0) }
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        completion(response?.data)
    }
}

public func emptyDataFetcher<Value: Codable>(
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher<Value> { completion in completion([]) }
}

public func userDefaultsDataFetcher<Value: Codable>(
    key: String,
    type: Value.Type = Value.self
) -> DataFetcher<Value> {
    DataFetcher { completion in
        let response = UserDefaults.standard
            .data(forKey: key)
            .flatMap { try? JSONDecoder().decode(Response<[Value]>.self, from: $0) }
        
        completion(response?.data)
    }
}
