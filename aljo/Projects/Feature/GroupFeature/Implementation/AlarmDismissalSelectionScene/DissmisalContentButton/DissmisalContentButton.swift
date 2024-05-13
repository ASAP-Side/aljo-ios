//
//  DissmisalContentButton.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/13/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

final class DissmisalContentButton: UIControl {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.body2)
    return label
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
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
    imageView.image = image
    configureUI()
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: Configure UI
extension DissmisalContentButton {
  private func selectedHandler() {
    if isSelected == true {
      layer.borderWidth = 1.5
      layer.borderColor = UIColor.red01.cgColor
      titleLabel.font = .pretendard(.headLine4)
      titleLabel.textColor = .red01
    } else {
      layer.borderWidth = 1
      layer.borderColor = UIColor.gray02.cgColor
      titleLabel.font = .pretendard(.body2)
      titleLabel.textColor = .black01
    }
  }
  
  private func configureUI() {
    configureHirearchy()
    configureConstraints()
  }
  
  private func configureHirearchy() {
    [imageView, titleLabel].forEach {
      addSubview($0)
    }
    
    layer.borderWidth = 1
    layer.borderColor = UIColor.gray02.cgColor
    layer.cornerRadius = 10
  }
  
  private func configureConstraints() {
    imageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(imageView.snp.trailing).offset(10)
      $0.centerY.equalToSuperview()
    }
  }
}
