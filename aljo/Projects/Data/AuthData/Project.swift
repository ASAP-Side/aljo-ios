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
        .domain(target: .AuthDomain, type: .interface),
        .rxSwift
      ]
    ),
    .implements(
      module: .data(.AuthData),
      dependencies: [
        .data(target: .AuthData, type: .interface),
        .core(target: .AJNetwork, type: .implementation),
        .rxSwift
      ]
    ),
    .testing(module: .data(.AuthData)),
    .tests(module: .data(.AuthData))
  ]
)
