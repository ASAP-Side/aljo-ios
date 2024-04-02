import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "HomeFeature",
  targets: [
    .implements(module: .feature(.HomeFeature))
  ]
)
