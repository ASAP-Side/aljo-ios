import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "AJNetwork",
  targets: [
    .interface(
      module: .core(.AJNetwork),
      dependencies: [
        .alamofire,
        .rxSwift
      ]
    ),
    .implements(
      module: .core(.AJNetwork),
      dependencies: [
        .core(target: .AJNetwork, type: .interface),
        .alamofire,
        .rxSwift,
        .swinject
      ]
    ),
    .testing(
      module: .core(.AJNetwork),
      product: .staticLibrary,
      dependencies: [
        .core(target: .AJNetwork, type: .interface),
        .alamofire,
        .rxSwift
      ]
    ),
    .tests(
      module: .core(.AJNetwork),
      dependencies: [
        .core(target: .AJNetwork, type: .implementation),
        .core(target: .AJNetwork, type: .testing),
        .alamofire,
        .rxSwift,
        .rxBlocking
      ]
    )
  ]
)
