import ProjectDescription
import ProjectDescriptionHelpers
import CodeSigning

let bundleIdentifier = "cz.ackee.enterprise.covid"
let deploymentTarget = DeploymentTarget.iOS(targetVersion: "15.0", devices: .iphone)

let core = Target(
    name: "CovidCore",
    platform: .iOS,
    product: .framework,
    bundleId: bundleIdentifier + ".core",
    deploymentTarget: deploymentTarget,
    infoPlist: .default,
    sources: "Features/CovidCore/**",
    dependencies: [
        .package(product: "CodableCSV")
    ]
)

let bars = Target.feature(
    name: "Bars",
    bundleIdentifier: bundleIdentifier + ".bars",
    deploymentTarget: deploymentTarget
)

let numberR = Target.feature(
    name: "NumberR",
    bundleIdentifier: bundleIdentifier + ".numberr",
    deploymentTarget: deploymentTarget
)

let dailyReport = Target.feature(
    name: "DailyReport",
    bundleIdentifier: bundleIdentifier + ".dailyReport",
    deploymentTarget: deploymentTarget
)

let settingsDictionary = SettingsDictionary()
    .customCodeSigning()
    .otherSwiftFlags("-Xfrontend -warn-long-function-bodies=300 -Xfrontend -warn-long-expression-type-checking=300")

let app = Target(
    name: "Covid",
    platform: .iOS,
    product: .app,
    bundleId: bundleIdentifier,
    deploymentTarget: deploymentTarget,
    infoPlist: .extendingDefault(with: [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UIMainStoryboardFile": "",
        "UILaunchStoryboardName": "LaunchScreen",
        "BGTaskSchedulerPermittedIdentifiers": [
            "cz.ackee.enterprise.covid.refreshData"
        ],
        "UISupportedInterfaceOrientations": [
            "UIInterfaceOrientationPortrait"
        ]
    ]),
    sources: ["Covid/**"],
    resources: ["Covid/Resources/**"],
    dependencies: [core, bars, numberR, dailyReport].map(\.name).map(TargetDependency.target)
)

let project = Project(
    name: "Covid",
    packages: [
        .remote(
            url: "https://github.com/dehesa/CodableCSV",
            requirement: .upToNextMajor(from: Version(0, 6, 7))
        )
    ],
    settings: Settings(base: settingsDictionary),
    targets: [app, core, bars, numberR, dailyReport]
)
