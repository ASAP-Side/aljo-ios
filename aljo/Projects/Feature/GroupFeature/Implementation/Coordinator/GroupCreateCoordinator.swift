//
//  GroupCreateCoordinator.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/6/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit
import FlowKitInterface
import GroupDomainInterface
import GroupDomainImplementation

public protocol GroupCreateCoordinator: Coordinator {
  func navigateGroupProfileSetting(with builder: GroupInformationBuilder)
  func presentImagePicker(delegate: ASImagePickerDelegate)
}

public final class AJGroupCreateCoordinator: GroupCreateCoordinator {
  public var childCoordinators: [Coordinator] = []
  private let navigationController: UINavigationController
  
  public init(
    navigationController: UINavigationController
  ) {
    self.navigationController = navigationController
  }
  
  public func start() {
    let viewModel = GroupPrivacySelectionViewModel(
      validGroupPasswordUseCase: AJValidGroupPasswordUseCase(),
      groupCreateCoordinator: self
    )
    let viewController = GroupPrivacySelectionViewController(
      viewModel: viewModel
    )
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func navigateGroupProfileSetting(with builder: GroupInformationBuilder) {
    let viewModel = GroupProfileSettingViewModel(coordinator: self)
    let viewController = GroupProfileSettingViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func presentImagePicker(delegate: ASImagePickerDelegate) {
    let navigationBarController = UINavigationController()
    let viewController = ASImagePickerViewController(max: 1)
    navigationBarController.setViewControllers([viewController], animated: false)
    viewController.delegate = delegate
    navigationBarController.modalPresentationStyle = .overFullScreen
    navigationController.present(navigationBarController, animated: true)
  }
}
