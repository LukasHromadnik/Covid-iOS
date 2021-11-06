//
//  CovidApp.swift
//  Covid
//
//  Created by Lukáš Hromadník on 24.04.2021.
//

import SwiftUI
import BackgroundTasks
import CovidCore

enum BackgroundTasksIdentifiers {
    static let refreshData = "cz.ackee.enterprise.covid.refreshData"
}

@main
struct CovidApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject
    private var dailyReportDataLoader = DailyReportDataLoader(
        dataFetcher: networkDataFetcher(url: DataSource.basicReport)
    )
    
    @ObservedObject
    private var cumulativeReportDataLoader = CumulativeReportDataLoader(
        dataFetcher: networkDataFetcher(url: DataSource.nakaza),
        dateProvider: .live
    )
    
    @ObservedObject
    private var lastUpdate = LastUpdate()
    
    init() {
        registerTasks()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dailyReportDataLoader)
                .environmentObject(cumulativeReportDataLoader)
                .environmentObject(lastUpdate)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                BGTaskScheduler.shared.cancelAllTaskRequests()
            
            case .background:
                scheduleAppRefresh()
            
            case .inactive:
                break
            
            @unknown default:
                break
            }
        }
    }
    
    private func registerTasks() {
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: BackgroundTasksIdentifiers.refreshData,
            using: nil
        ) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }
    }
    
    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: BackgroundTasksIdentifiers.refreshData)
        print(determineNextDate())
        request.earliestBeginDate = determineNextDate()
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("could not scheulde app refresh: \(error)")
        }
    }
    
    private func determineNextDate() -> Date {
        let midnightSeconds = (Date().timeIntervalSince1970 / 86400).rounded(.towardZero) * 86400
        let todaySeconds = Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 86400)
        
        // Since we are +2 hours, all times must be -2 hours aligned
        // 8:15 AM
        if todaySeconds < 22500 {
            return Date(timeIntervalSince1970: midnightSeconds).addingTimeInterval(29700)
        }
        // 9:00 AM
        else if todaySeconds < 25200 {
            return Date(timeIntervalSinceNow: 900) // 15 minutes
        }
        // Set the next update to 8:30 AM next day
        else {
            return Date(timeIntervalSince1970: midnightSeconds).addingTimeInterval(108900)
        }
    }
    
    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()
        
        let group = DispatchGroup()
        group.notify(queue: .main) {
            task.setTaskCompleted(success: true)
            lastUpdate.date = Date()
        }
        
        group.enter()
        dailyReportDataLoader.refresh { group.leave() }
        
        group.enter()
        cumulativeReportDataLoader.refresh { group.leave() }
    }
}
