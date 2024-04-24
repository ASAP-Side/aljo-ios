import ProjectDescription

public extension TargetDependency {
  static let rxSwift = Self.external(name: "RxSwift")
  static let rxCocoa = Self.external(name: "RxCocoa")
  static let rxRelay = Self.external(name: "RxRelay")
  static let rxBlocking = Self.external(name: "RxBlocking")
  static let rxTest = Self.external(name: "RxTest")
  static let snapKit = Self.external(name: "SnapKit")
  static let alamofire = Self.external(name: "Alamofire")
  static let swinject = Self.external(name: "Swinject")
}

