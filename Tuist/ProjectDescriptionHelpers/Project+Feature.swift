import ProjectDescription

public extension Target {
    static func feature(
        name: String,
        bundleIdentifier: String,
        deploymentTarget: DeploymentTarget
    ) -> Self {
        Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: "Features/\(name)/**",
            dependencies: [.target(name: "CovidCore")]
        )
    }
}
