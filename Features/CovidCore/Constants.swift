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
    public static let nakaza = "https://onemocneni-aktualne.mzcr.cz/api/v3/nakazeni-vyleceni-umrti-testy?apiToken=\(Constants.apiToken)"
    public static let basicReport = "https://onemocneni-aktualne.mzcr.cz/api/v3/zakladni-prehled?apiToken=\(Constants.apiToken)"
    public static let incidence = "https://onemocneni-aktualne.mzcr.cz/api/v3/incidence-7-14-cr?apiToken=\(Constants.apiToken)"
}
