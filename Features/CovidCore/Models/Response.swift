//
//  Response.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import Foundation

public struct Response<Data: Codable>: Codable {
    public let data: Data
}
