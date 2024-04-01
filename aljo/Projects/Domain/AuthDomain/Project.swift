import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "AuthDomain",
  targets: [
    .interface(module: .domain(.AuthDomain)),
    .implements(module: .domain(.AuthDomain))
  ]
)
