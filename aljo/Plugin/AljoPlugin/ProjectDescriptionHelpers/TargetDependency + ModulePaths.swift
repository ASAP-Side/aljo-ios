import Foundation
import ProjectDescription

public extension TargetDependency {
  static func feature(
    target: ModulePaths.Feature,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToFeature(target.rawValue)
    )
  }
  
  static func domain(
    target: ModulePaths.Domain,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToDomain(target.rawValue)
    )
  }
  
  static func core(
    target: ModulePaths.Core,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToCore(target.rawValue)
    )
  }
  
  static func shared(
    target: ModulePaths.Shared,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToShare(target.rawValue)
    )
  }
  
  static func design(
    target: ModulePaths.Design,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToDesign(target.rawValue)
    )
  }
  
  static func data(
    target: ModulePaths.Data,
    type: TargetType
  ) -> TargetDependency {
    return .project(
      target: target.targetName(type: type),
      path: .relativeToData(target.rawValue)
    )
  }
}
