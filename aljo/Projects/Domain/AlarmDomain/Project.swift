import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

let targets: [Target] = [
  Target(
    name: "AlarmDomain",
    platform: .iOS,
    product: .staticFramework,
    bundleId: "com.asap.alarmDomain",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
    sources: ["Sources/**"],
    dependencies: [
      .project(target: "BaseDomain", path: "../BaseDomain"),
      .project(target: "AlarmDomainInterface", path: "")
    ]
  ),
  Target(
    name: "AlarmDomainInterface",
    platform: .iOS,
    product: .framework,
    bundleId: "com.asap.alarmDomain",
    deploymentTarget: .iOS(targetVersion: "14.0", devices: .iphone),
    sources: ["Interface/**"]
  )
]

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(name: "AlarmDomain", targets: targets)