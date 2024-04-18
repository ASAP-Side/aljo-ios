import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: SwiftPackageManagerDependencies(
    [
      .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.6.0")),
      .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .exact("5.8.1")),
      .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.6.0")),
      .remote(url: "https://github.com/kakao/kakao-ios-sdk-rx", requirement: .exact("2.20.0"))
    ]
  ),
  platforms: [.iOS]
)
