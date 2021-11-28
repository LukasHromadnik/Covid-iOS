import ProjectDescription

public extension Target {
    static func feature(
        name: String,
        bundleIdentifier: String,
        deploymentTarget: DeploymentTarget,
        hasResources: Bool = false
    ) -> Self {
        Target(
            name: name,
            platform: .iOS,
            product: .framework,
            bundleId: bundleIdentifier,
            deploymentTarget: deploymentTarget,
            infoPlist: .default,
            sources: "Features/\(name)/**",
            resources: hasResources ? "Features/\(name)/Resources/**" : nil,
            dependencies: [.target(name: "CovidCore")]
        )
    }
}
