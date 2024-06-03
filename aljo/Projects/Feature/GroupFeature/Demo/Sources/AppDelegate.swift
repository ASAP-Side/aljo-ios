import UIKit

import GroupFeatureImplementation
import GroupDomainImplementation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  var coordinator: GroupCreateDemoCoordinator?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .systemBackground
    
    coordinator = GroupCreateDemoCoordinator(window: window)
    coordinator?.start()
    return true
  }
}
