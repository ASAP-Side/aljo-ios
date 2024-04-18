import UIKit

import AuthFeatureImplementation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .systemBackground
    let authorizationManager = AuthorizationManager()
    let controller = LoginViewController(
      viewModel: LoginViewModel(
        authorizationManager: authorizationManager
      )
    )
    window?.rootViewController = controller
    window?.makeKeyAndVisible()
    return true
  }
}
