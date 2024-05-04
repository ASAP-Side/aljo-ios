//
//  GroupDemoRootViewController.swift
//  GroupFeatureDemo
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import GroupFeatureImplementation

final class GroupDemoRootViewController: UIViewController {
  private let pushButton: UIButton = {
    let button = UIButton()
    button.setTitle("push", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  override func viewDidLoad() {
    view.addSubview(pushButton)
    view.backgroundColor = .systemBackground
    
    NSLayoutConstraint.activate([
      pushButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      pushButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
    
    let action = UIAction { [weak self] _ in
      let viewController = GroupPrivacySelectionViewController(
        viewModel: GroupPrivacySelectionViewModel()
      )
      self?.navigationController?.pushViewController(
        viewController,
        animated: true
      )
    }
    navigationController?.navigationBar.isTranslucent = false
    
    pushButton.addAction(action, for: .touchUpInside)
  }
}
