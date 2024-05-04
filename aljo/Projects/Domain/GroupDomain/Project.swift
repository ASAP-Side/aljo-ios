import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "GroupDomain",
  targets: [
    .interface(
      module: .domain(.GroupDomain),
      dependencies: [
        .rxSwift
      ]
    ),
    .implements(
      module: .domain(.GroupDomain),
      dependencies: [
        .domain(target: .GroupDomain, type: .interface),
        .rxSwift,
        .swinject
      ]
    ),
    .testing(
      module: .domain(.GroupDomain),
      dependencies: [
        .domain(target: .GroupDomain, type: .interface),
        .rxSwift,
      ]
    )
  ]
)
