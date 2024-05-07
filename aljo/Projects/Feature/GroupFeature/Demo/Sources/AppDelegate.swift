import UIKit

import GroupFeatureImplementation
import GroupDomainImplementation

import Swinject

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
    
    let assembler = Assembler(
      [
        GroupFeatureAssembly(),
        GroupDomainAssembly()
      ]
    )
    coordinator = GroupCreateDemoCoordinator(window: window, assembler: assembler)
    coordinator?.start()
    return true
  }
}

final class GroupCreateDemoCoordinator {
  private var childCoordinator: [GroupCreateCoordinator?] = []
  private let window: UIWindow?
  private let navigationController = UINavigationController()
  private let assembler: Assembler
  
  init(
    window: UIWindow?,
    assembler: Assembler
  ) {
    self.window = window
    self.assembler = assembler
  }
  
  func start() {
    let controller = GroupDemoRootViewController()
    controller.coordinator = self
    navigationController.viewControllers = [controller]
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func navigateGroupPrivacySelection() {
    let coordinator = assembler.resolver.resolve(
      GroupCreateCoordinator.self,
      arguments: navigationController, assembler
    )
    coordinator?.start()
    childCoordinator.append(coordinator)
  }
}
