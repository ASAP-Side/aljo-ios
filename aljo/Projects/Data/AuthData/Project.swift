import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "AuthData",
  targets: [
    .interface(
      module: .data(.AuthData),
      dependencies: [
        .rxSwift
      ]
    ),
    .implements(
      module: .data(.AuthData),
      dependencies: [
        .data(target: .AuthData, type: .interface),
        .rxSwift
      ]
    ),
    .testing(module: .data(.AuthData)),
    .tests(module: .data(.AuthData))
  ]
)
