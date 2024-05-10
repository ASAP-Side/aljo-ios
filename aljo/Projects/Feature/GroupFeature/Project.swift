import ProjectDescription
import ProjectDescriptionHelpers

// Plugins
import AljoPlugin
import EnvironmentPlugin

let project = Project.app(
  to: "GroupFeature",
  targets: [
    .implements(
      module: .feature(.GroupFeature),
      dependencies: [
        .feature(target: .BaseFeature, type: .interface),
        .domain(target: .GroupDomain, type: .interface),
        .design(target: .ASAPKit, type: .single),
        .shared(target: .FlowKit, type: .interface),
        .rxSwift,
        .rxCocoa,
        .snapKit
      ]
    ),
    .demo(
      module: .feature(.GroupFeature),
      dependencies: [
        .feature(target: .GroupFeature, type: .implementation),
        .domain(target: .GroupDomain, type: .implementation)
      ],
      infoPlist: .extendingDefault(
        with: [
          "UIMainStoryboardFile": "",
          "UILaunchStoryboardName": "LaunchScreen",
          "NSPhotoLibraryUsageDescription": "사진에 접근할 수 있는 권한이 필요합니다."
        ]
      )
    )
  ]
)
