//
//  ProgressNavigationViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/7/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import SnapKit

public final class ProgressNavigationViewController: UINavigationController {
  private let progressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.progressTintColor = .red01
    progressView.trackTintColor = .gray01
    progressView.isHidden = true
    return progressView
  }()
  public var stepCount: Int? {
    didSet {
      progressView.isHidden = stepCount == nil ? true : false
    }
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
    configureUI()
  }
  
  private func configureUI() {
    navigationBar.addSubview(progressView)
    
    progressView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(2)
    }
  }
}

extension ProgressNavigationViewController: UINavigationControllerDelegate {
  public func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool
  ) {
    
    guard let stepCount = stepCount else {
      return
    }
    
    let progress = Float(viewControllers.count - 1) / Float(stepCount)
    progressView.setProgress(progress, animated: true)
  }
}
