import ProjectDescription

let dependencies = Dependencies(
  carthage: [
    .binary(path: "https://dl.google.com/dl/firebase/ios/carthage/FirebaseMessagingBinary.json", requirement: .exact("10.14.0")),
    .github(path: "SnapKit/SnapKit", requirement: .exact("5.6.0")),
    .github(path: "Alamofire/Alamofire", requirement: .exact("5.6.3")),
    .github(path: "ReactiveX/RxSwift", requirement: .exact("6.6.0")),
  ],
  swiftPackageManager: [
    .remote(
      url: "https://github.com/kakao/kakao-ios-sdk",
      requirement: .upToNextMajor(from: "2.20.0")
    )
  ],
  platforms: [.iOS]
)
