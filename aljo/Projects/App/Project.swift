import ProjectDescription
import ProjectDescriptionHelpers
import AljoPlugin
import EnvironmentPlugin

let configurations: [Configuration] = [
  .debug(name: "Debug", xcconfig: .relativeToRoot("XCConfig/API_KEY.xcconfig")),
  .release(name: "Release", xcconfig: .relativeToRoot("XCConfig/API_KEY.xcconfig"))
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
      "UILaunchStoryboardName": "LaunchScreen",
      "LSApplicationQueriesSchemes": ["kakaokompassauth"],
      "KakaoNativeAppKey": "${KAKAO_NATIVE_APP_KEY}",
      "URL types": [
        [
          "Document Role": "Editor",
         "URL Schemes": ["kakao${KAKAO_NATIVE_APP_KEY}"]
        ]
      ]
    ]),
    sources: ["Sources/**"],
    resources: ["Resources/**"],
    scripts: [.swiftLintTargetScript],
    dependencies: ModulePaths.Feature.allCases.map { TargetDependency.feature(target: $0, type: .implementation) }
    + ModulePaths.Domain.allCases.map { TargetDependency.domain(target: $0, type: .interface) }
    + ModulePaths.Domain.allCases.map { TargetDependency.domain(target: $0, type: .implementation) }
    + ModulePaths.Core.allCases.map { TargetDependency.core(target: $0, type: .interface) }
    + ModulePaths.Core.allCases.map { TargetDependency.core(target: $0, type: .implementation) },
    settings: settings
  )
]

let project = Project(
  name: environmentValues.name,
  organizationName: environmentValues.organizationName,
  settings: settings,
  targets: targets
)
