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

let bars = Target(
    name: "Bars",
    platform: .iOS,
    product: .framework,
    bundleId: bundleIdentifier + ".bars",
    infoPlist: .default,
    sources: "Features/Bars/**",
    dependencies: [.target(name: "CovidCore")]
)

let numberR = Target(
    name: "NumberR",
    platform: .iOS,
    product: .framework,
    bundleId: bundleIdentifier + ".numberr",
    infoPlist: .default,
    sources: "Features/NumberR/**",
    dependencies: [.target(name: "CovidCore")]
)

let settingsDictionary = SettingsDictionary()
    .customCodeSigning()
    .otherSwiftFlags("-Xfrontend -warn-long-function-bodies=300 -Xfrontend -warn-long-expression-type-checking=300")

let project = Project.app(
    name: "Covid",
    bundleIdentifier: bundleIdentifier,
    settingsDictionary: settingsDictionary,
    targets: [core, bars, numberR]
)
