import ProjectDescription
import ProjectDescriptionHelpers
import AljoPlugin
import EnvironmentPlugin

let configurations: [Configuration] = [
  .debug(name: "Debug"),
  .release(name: "Release")
]

let settings = Settings.settings(
  base: environmentValues.baseSetting,
  configurations: configurations
)

let targets: [Target] = [
  Target(
    name: environmentValues.name,
    platform: environmentValues.platform,
    product: .app,
    bundleId: environmentValues.organizationName + "." + environmentValues.name,
    deploymentTarget: environmentValues.deployTarget,
    infoPlist: .extendingDefault(with: [
      "UILaunchStoryboardName": "LaunchScreen"
    ]),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    scripts: [.swiftLintTargetScript],
    dependencies: ModulePaths.Feature.allCases.map { TargetDependency.feature(target: $0, type: .interface) }
    + ModulePaths.Domain.allCases.map { TargetDependency.domain(target: $0, type: .interface) }
    + ModulePaths.Core.allCases.map { TargetDependency.core(target: $0, type: .interface) },
    settings: settings
  )
]

let project = Project(
  name: environmentValues.name,
  organizationName: environmentValues.organizationName,
  settings: settings,
  targets: targets
)
