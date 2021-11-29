//
//  Response.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct Response<Value> {
    public let data: Value
}

extension Response: Codable where Value: Codable {
    enum CodingKeys: String, CodingKey {
        case datav2 = "data"
        case datav3 = "hydra:member"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let data = try? container.decode(Value.self, forKey: .datav2) {
            self.data = data
        } else if let data = try? container.decode(Value.self, forKey: .datav3) {
            self.data = data
        } else {
            throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [], debugDescription: "", underlyingError: nil))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(data, forKey: .datav2)
    }
}
