import ProjectDescription
import ProjectDescriptionHelpers
import CodeSigning

let bundleIdentifier = "cz.ackee.enterprise.covid"

let core = Target(
    name: "CovidCore",
    platform: .iOS,
    product: .framework,
    bundleId: bundleIdentifier + ".core",
    infoPlist: .default,
    sources: "Features/CovidCore/**"
)

let bars = Target.graph(
    name: "Bars",
    bundleIdentifier: bundleIdentifier + ".bars"
)

let numberR = Target.graph(
    name: "NumberR",
    bundleIdentifier: bundleIdentifier + ".numberr"
)

let dailyReport = Target.graph(
    name: "DailyReport",
    bundleIdentifier: bundleIdentifier + ".dailyReport"
)

let settingsDictionary = SettingsDictionary()
    .customCodeSigning()
    .otherSwiftFlags("-Xfrontend -warn-long-function-bodies=300 -Xfrontend -warn-long-expression-type-checking=300")

let project = Project.app(
    name: "Covid",
    bundleIdentifier: bundleIdentifier,
    settingsDictionary: settingsDictionary,
    targets: [core, bars, numberR, dailyReport]
)
