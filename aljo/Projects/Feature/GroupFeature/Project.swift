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
        .feature(target: .BaseFeature, type: .interface),
        .domain(target: .GroupDomain, type: .interface),
        .design(target: .ASAPKit, type: .single),
        .rxSwift,
        .rxCocoa,
        .snapKit
      ]
    ),
    .demo(
      module: .feature(.GroupFeature),
      dependencies: [
        .feature(target: .GroupFeature, type: .implementation),
        .domain(target: .GroupDomain, type: .implementation)
      ]
    )
  ]
)
