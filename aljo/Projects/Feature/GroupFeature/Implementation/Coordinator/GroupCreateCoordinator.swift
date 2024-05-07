//
//  GroupCreateCoordinator.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/6/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import FlowKitInterface
import GroupDomainInterface

import Swinject

public protocol GroupCreateCoordinator: Coordinator {
  func navigateGroupProfileSetting(with builder: GroupInformationBuilder)
}

public final class AJGroupCreateCoordinator: GroupCreateCoordinator {
  public var childCoordinators: [Coordinator] = []
  private let navigationController: UINavigationController
  private let assembler: Assembler
  
  public init(
    navigationController: UINavigationController,
    assembler: Assembler
  ) {
    self.navigationController = navigationController
    self.assembler = assembler
  }
  
  public func start() {
    let viewModel = assembler.resolver.resolve(
      GroupPrivacySelectionViewModel.self,
      argument: self as GroupCreateCoordinator?
    )!
    let viewController = assembler.resolver.resolve(
      GroupPrivacySelectionViewController.self,
      argument: viewModel
    )!
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func navigateGroupProfileSetting(with builder: GroupInformationBuilder) {
    
  }
}
