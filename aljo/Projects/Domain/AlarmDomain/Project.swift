import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(to: "AlarmDomain") {
  [
    .interface(module: .domain(.AlarmDomain)),
    .implements(module: .domain(.AlarmDomain)) {
      [
        .domain(target: .BaseDomain),
        .domain(target: .AlarmDomain, type: .interface)
      ]
    }
  ]
}