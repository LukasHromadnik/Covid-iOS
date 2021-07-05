//
//  Constants.swift
//  Bars
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import UIKit

public enum Constants {
    public static let graphMaxHeight: CGFloat = 300
}

public enum DataSource {
    public static let nakaza = "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/nakazeni-vyleceni-umrti-testy.min.json"
    public static let basicReport = "https://onemocneni-aktualne.mzcr.cz/api/v2/covid-19/zakladni-prehled.min.json"
}
