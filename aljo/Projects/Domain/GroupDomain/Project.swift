import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "GroupDomain",
  targets: [
    .interface(
      module: .domain(.GroupDomain)
    ),
    .implements(
      module: .domain(.GroupDomain),
      dependencies: [
        .domain(target: .GroupDomain, type: .interface)
      ]
    )
  ]
)
