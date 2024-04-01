import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "BaseFeature",
  targets: [
    .implements(module: .feature(.BaseFeature))
  ]
)
