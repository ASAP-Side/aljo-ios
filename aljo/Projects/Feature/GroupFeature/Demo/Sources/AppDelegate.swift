import UIKit

import GroupFeatureImplementation

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

final class GroupCreateDemoCoordinator {
  private var childCoordinator: [GroupCreateCoordinator] = []
  private let window: UIWindow?
  private let navigationController = UINavigationController()
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  func start() {
    let controller = GroupDemoRootViewController()
    controller.coordinator = self
    navigationController.viewControllers = [controller]
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func navigateGroupPrivacySelection() {
    let coordinator = AJGroupCreateCoordinator(
      navigationController: navigationController
    )
    coordinator.start()
    childCoordinator.append(coordinator)
  }
}
