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
  func presentImagePickMenu(
    delegate: ASImagePickerDelegate & GroupRandomImageDelegate
  )
  func presentImagePicker(delegate: ASImagePickerDelegate)
  func presentTimeSelect(delegate: TimePickerBottomSheetDelegate, date: Date?)
  func navigateAlarmDismissalSelectionViewController()
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
    let viewModel = GroupProfileSettingViewModel(
      coordinator: self,
      groupInformationBuilder: builder
    )
    let viewController = GroupProfileSettingViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  public func navigateAlarmDismissalSelectionViewController() {
    
  }
  
  public func presentImagePickMenu(
    delegate: ASImagePickerDelegate & GroupRandomImageDelegate
  ) {
    let contents = [
      MenuListCellContent(
        image: .Icon.picture_color,
        text: "앨범에서 선택하기",
        action: { [weak self] in
          self?.presentImagePicker(delegate: delegate)
        }
      ),
      MenuListCellContent(
        image: .Icon.arrow_circle,
        text: "랜덤으로 바꾸기",
        action: {
          delegate.generateRandomImage()
        }
      )
    ]
    let viewController = MenuListBottomSheetController(
      title: "이미지 변경",
      detent: .custom(0.7),
      contents: contents
    )
    navigationController.present(viewController, animated: true)
  }
  
  public func presentImagePicker(delegate: ASImagePickerDelegate) {
    let navigationBarController = UINavigationController()
    let viewController = ASImagePickerViewController(max: 1)
    navigationBarController.setViewControllers([viewController], animated: false)
    viewController.delegate = delegate
    navigationBarController.modalPresentationStyle = .overFullScreen
    navigationController.present(navigationBarController, animated: true)
  }
  
  public func presentTimeSelect(delegate: TimePickerBottomSheetDelegate, date: Date?) {
    let viewController = TimePickerBottomSheetController(
      detents: .custom(0.4625),
      date: date ?? Date()
    )
    viewController.delegate = delegate
    navigationController.present(viewController, animated: true)
  }
}
