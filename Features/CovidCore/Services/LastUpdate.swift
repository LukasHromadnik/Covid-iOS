//
//  LastUpdate.swift
//  CovidCore
//
//  Created by Lukáš Hromadník on 07.07.2021.
//

import Foundation

public final class LastUpdate: ObservableObject {
    public var date: Date? {
        get { UserDefaults.standard.value(forKey: "lastUpdate.date") as? Date }
        set { UserDefaults.standard.setValue(newValue, forKey: "lastUpdate.date") }
    }
    
    public init() { }
}
