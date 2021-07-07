import ProjectDescription

public extension Project {
    static func app(
        name: String,
        bundleIdentifier: String,
        settingsDictionary: SettingsDictionary,
        targets: [Target]
    ) -> Project {
        let app = Target(
            name: name,
            platform: .iOS,
            product: .app,
            bundleId: bundleIdentifier,
            infoPlist: .extendingDefault(with: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1",
                "UIMainStoryboardFile": "",
                "UILaunchStoryboardName": "LaunchScreen",
                "BGTaskSchedulerPermittedIdentifiers": [
                    "cz.ackee.enterprise.covid.refreshData"
                ]
            ]),
            sources: ["\(name)/**"],
            resources: ["\(name)/Resources/**"],
            dependencies: targets.map(\.name).map(TargetDependency.target)
        )

        return Project(
            name: name,
            settings: Settings(base: settingsDictionary),
            targets: [app] + targets
        )
    }
}
