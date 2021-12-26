//
//  Response.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct Response<Value> {
    public let data: Value
    public let totalItems: Int
}

extension Response {
    static func data(_ value: Value) -> Response<Value> {
        Response(data: value, totalItems: 0)
    }
}

extension Response: Codable where Value: Codable {
    enum CodingKeys: String, CodingKey {
        case data = "hydra:member"
        case totalItems = "hydra:totalItems"
    }
}
