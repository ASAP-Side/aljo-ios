import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "AuthDomain",
  targets: [
    .interface(
      module: .domain(.AuthDomain),
      dependencies: [.rxSwift]
    ),
    .implements(
      module: .domain(.AuthDomain),
      dependencies: [
        .domain(target: .AuthDomain, type: .interface),
        .rxSwift
      ]
    ),
    .demo(module: .domain(.AuthDomain)),
    .testing(module: .domain(.AuthDomain)),
    .tests(module: .domain(.AuthDomain))
  ]
)
