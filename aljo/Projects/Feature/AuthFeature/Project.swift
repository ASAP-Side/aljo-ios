import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "AuthFeature",
  targets: [
    .implements(
      module: .feature(.AuthFeature),
      dependencies: [
        .design(target: .ASAPKit, type: .single),
        .rxSwift,
        .rxCocoa
      ]
    ),
    .tests(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature, type: .implementation),
        .rxBlocking,
        .rxTest
      ]
    ),
    .demo(
      module: .feature(.AuthFeature),
      dependencies: [
        .feature(target: .AuthFeature, type: .implementation)
      ]
    )
  ]
)
