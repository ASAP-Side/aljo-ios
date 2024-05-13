//
//  PrivacyButton.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import SnapKit

final class PrivacyButton: UIControl {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.headLine4)
    label.textColor = .black01
    return label
  }()
  
  private let leftImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private let rightImageView: UIImageView = {
    let imageView = UIImageView()
    // TODO: 이미지 변경
    imageView.image = .Icon.camera_gray
    return imageView
  }()
  
  override var isSelected: Bool {
    get {
      super.isSelected
    }
    set {
      super.isSelected = newValue
      selectedHandler()
    }
  }
  
  init(image: UIImage, title: String) {
    super.init(frame: .zero)
    
    titleLabel.text = title
    leftImageView.image = image
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Configure Action
extension PrivacyButton {
  private func configureGesture() {
    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(didTapButton)
    )
    addGestureRecognizer(tapGesture)
  }
  
  @objc
  private func didTapButton() {
    sendActions(for: .touchUpInside)
  }
}

// MARK: Configure UI
extension PrivacyButton {
  private func selectedHandler() {
    if isSelected == true {
      layer.borderColor = UIColor.red01.cgColor
      backgroundColor = .red02
      rightImageView.image = .Icon.circle_check_color
    } else {
      layer.borderColor = UIColor.gray02.cgColor
      backgroundColor = .white
      rightImageView.image = .Icon.circle_check_gray
    }
  }
  
  private func configureUI() {
    configureHirearchy()
    configureConstraints()
  }
  
  private func configureHirearchy() {
    [titleLabel, leftImageView, rightImageView].forEach {
      addSubview($0)
    }
    
    layer.borderWidth = 1
    layer.borderColor = UIColor.gray02.cgColor
    layer.cornerRadius = 10
  }
  
  private func configureConstraints() {
    leftImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
      $0.bottom.equalToSuperview().offset(-20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(leftImageView.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
    }
    
    rightImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
    }
  }
}
