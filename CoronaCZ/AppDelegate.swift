//
//  AppDelegate.swift
//  CoronaCZ
//
//  Created by Lukáš Hromadník on 11/04/2020.
//  Copyright © 2020 Lukáš Hromadník. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = ViewController()
        let rootViewController = UINavigationController(rootViewController: controller)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        return true
    }
}
