import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "BaseFeature",
  targets: [
    .interface(module: .feature(.BaseFeature)),
    .implements(module: .feature(.BaseFeature))
  ]
)
