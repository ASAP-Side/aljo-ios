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
        .feature(target: .BaseFeature, type: .interface),
        .design(target: .ASAPKit, type: .single),
        .domain(target: .AuthDomain, type: .interface),
        .rxSwift,
        .rxCocoa,
        .rxKakaoSDKCommon,
        .rxKakaoSDKAuth,
        .rxKakaoSDKUser
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
        .feature(target: .AuthFeature, type: .implementation),
        .domain(target: .AuthDomain, type: .testing)
      ]
    )
  ]
)
