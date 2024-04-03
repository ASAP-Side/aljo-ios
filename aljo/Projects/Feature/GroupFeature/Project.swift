import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "GroupFeature",
  targets: [
    .implements(
      module: .feature(.GroupFeature),
      dependencies: [
        .feature(target: .BaseFeature, type: .interface)
      ]
    )
  ]
)
