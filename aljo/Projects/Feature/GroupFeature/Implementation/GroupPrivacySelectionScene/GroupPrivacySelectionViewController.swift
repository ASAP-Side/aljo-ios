//
//  GroupPrivacySelectionViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import SnapKit

public final class GroupPrivacySelectionViewController: UIViewController {
  // MARK: Components
  private let stepProgressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.progressTintColor = .red01
    progressView.trackTintColor = .gray01
    progressView.progress = 0.5
    return progressView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "어떤 알람을 만드시겠어요?"
    label.textColor = .black01
    label.font = .pretendard(.headLine1)
    return label
  }()
  
  private let subTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "그룹 생성 후에도 변경이 가능해요!"
    label.textColor = .black03
    label.font = .pretendard(.body4)
    return label
  }()
  
  // TODO: 이미지 변경
  private let publicButton = PrivacyButton(
    image: .Icon.arrow_circle,
    title: "공개"
  )
  
  private let privateButton = PrivacyButton(
    image: .Icon.arrow_circle,
    title: "비공개"
  )
  
  private let passwordTextField: ASUnderBarTextField = {
    let textField = ASUnderBarTextField()
    textField.placeHolder = "비밀번호 4자리를 입력해주세요"
    textField.maxTextCount = 4
    return textField
  }()
  
  private let nextButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "다음"
    return button
  }()
  
  public override func viewDidLoad() {
    configureUI()
    
    
  }
  
  public override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
  ) {
    view.endEditing(true)
  }
}

// MARK: Configure UI
extension GroupPrivacySelectionViewController {
  private func configureUI() {
    configureHirearchy()
    configureConstraints()
    
    if #available(iOS 17.0, *) {
      view.keyboardLayoutGuide.usesBottomSafeArea = false
    }
  }
  
  private func configureHirearchy() {
    [
      stepProgressView,
      titleLabel,
      subTitleLabel,
      publicButton,
      privateButton,
      passwordTextField,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  private func configureConstraints() {
    stepProgressView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(2)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(stepProgressView.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4)
      $0.leading.equalToSuperview().offset(20)
    }
    
    publicButton.snp.makeConstraints {
      $0.top.equalTo(subTitleLabel.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    privateButton.snp.makeConstraints {
      $0.top.equalTo(publicButton.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(privateButton.snp.bottom).offset(54)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        .offset(-safeAreaBottomInset())
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.065)
    }
  }
  
  private func safeAreaBottomInset() -> CGFloat {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    if scene?.windows.first?.safeAreaInsets.bottom == 0 {
      return 10
    }
    
    return scene?.windows.first?.safeAreaInsets.bottom ?? .zero
  }
}
