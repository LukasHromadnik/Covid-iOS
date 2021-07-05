//
//  CovidApp.swift
//  Covid
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import SwiftUI

@main
struct CovidApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
//
//BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.apple-samplecode.ColorFeed.refresh", using: nil) { task in
//    // Downcast the parameter to an app refresh task as this identifier is used for a refresh request.
//    self.handleAppRefresh(task: task as! BGAppRefreshTask)
//}

//let request = BGAppRefreshTaskRequest(identifier: "com.example.apple-samplecode.ColorFeed.refresh")
//request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60) // Fetch no earlier than 15 minutes from now
//
//do {
//    try BGTaskScheduler.shared.submit(request)
//} catch {
//    print("Could not schedule app refresh: \(error)")
//}
//}
