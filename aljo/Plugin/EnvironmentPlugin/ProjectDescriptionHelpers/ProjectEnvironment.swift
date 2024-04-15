import Foundation
import ProjectDescription

public struct ProjectEnvironment {
  public let name: String
  public let organizationName: String
  public let deployTarget: DeploymentTarget
  public let platform: Platform
  public let baseSetting: SettingsDictionary
}

public let environmentValues = ProjectEnvironment(
  name: "aljoapp",
  organizationName: "com.asap",
  deployTarget: .iOS(targetVersion: "15.0", devices: .iphone),
  platform: .iOS,
  baseSetting: [:]
)
