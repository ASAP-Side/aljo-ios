import ProjectDescription

public enum ModulePaths {
  case feature(Feature)
  case domain(Domain)
  case data(Data)
  case core(Core)
  case shared(Shared)
  case design(Design)
}

public extension ModulePaths {
  enum Feature: String, TargetPathConvertible {
    case AuthFeature
    case HomeFeature
    case GroupFeature
    case SettingFeature
    case BaseFeature
  }
  
  enum Domain: String, TargetPathConvertible {
    case AuthDomain
    case GroupDomain
  }
  
  enum Data: String, TargetPathConvertible {
    case AuthData
  }
  
  enum Core: String, TargetPathConvertible {
    case AJNetwork
    case AJKeychain
    case AJCoreData
  }
  
  enum Shared: String, TargetPathConvertible {
    case Foundation
    case FlowKit
  }
  
  enum Design: String, TargetPathConvertible {
    case ASAPKit
  }
}

public extension ModulePaths {
  func targetName(type: TargetType) -> String {
    switch self {
      case .feature(let feature):
        return feature.targetName(type: type)
      case .domain(let domain):
        return domain.targetName(type: type)
      case .data(let data):
        return data.targetName(type: type)
      case .core(let core):
        return core.targetName(type: type)
      case .shared(let shared):
        return shared.targetName(type: type)
      case .design(let design):
        return design.targetName(type: type)
    }
  }
}

public enum TargetType: String {
  case interface = "Interface"
  case implementation = "Implementation"
  case tests = "Tests"
  case testing = "Testing"
  case demo = "Demo"
  case single = ""
}

public protocol TargetPathConvertible {
  func targetName(type: TargetType) -> String
}

public extension TargetPathConvertible where Self: RawRepresentable {
  func targetName(type: TargetType) -> String {
    return "\(self.rawValue)\(type.rawValue)"
  }
}

extension ModulePaths.Feature: CaseIterable { }
extension ModulePaths.Domain: CaseIterable { }
extension ModulePaths.Data: CaseIterable { }
extension ModulePaths.Core: CaseIterable { }
extension ModulePaths.Design: CaseIterable { }
extension ModulePaths.Shared: CaseIterable { }
