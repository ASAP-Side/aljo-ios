import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let targets: [Target] = [
  .interface(
    module: .core(.AJKeychain),
    dependencies: [.rxSwift]
  ),
  .implements(
    module: .core(.AJKeychain),
    dependencies: [
      .core(target: .AJKeychain, type: .interface),
      .rxSwift,
      .swinject
    ]
  )
]

let project = Project(name: "AJKeychain", targets: targets)
