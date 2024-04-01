import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "SettingFeature",
  targets: [
    .implements(module: .feature(.BaseFeature)),
    .implements(module: .feature(.SettingFeature))
  ]
)
