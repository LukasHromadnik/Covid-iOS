import ProjectDescription

public extension Target {
    static func graph(
        name: String,
        bundleIdentifier: String
    ) -> Self {
        Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            infoPlist: .default,
            sources: "Features/\(name)/**",
            dependencies: [.target(name: "CovidCore")]
        )
    }
}
