//
//  GroupFeatureAssembly.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/6/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import GroupDomainInterface

import Swinject

public final class GroupFeatureAssembly: Assembly {
  public init() { }
  
  public func assemble(container: Container) {
    container.register(GroupPrivacySelectionViewModel.self) { resolver, coordinator in
      GroupPrivacySelectionViewModel(
        validGroupPasswordUseCase: resolver.resolve(ValidGroupPasswordUseCase.self)!,
        groupCreateCoordinator: coordinator
      )
    }
    
    container.register(GroupPrivacySelectionViewController.self) { _, viewModel in
      GroupPrivacySelectionViewController(
        viewModel: viewModel
      )
    }
    
    container.register(GroupCreateCoordinator.self) { _, navigationController, assembler in
      AJGroupCreateCoordinator(navigationController: navigationController, assembler: assembler)
    }
  }
}
