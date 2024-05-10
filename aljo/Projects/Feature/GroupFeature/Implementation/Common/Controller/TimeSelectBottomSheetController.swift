//
//  TimeSelectBottomSheetController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/10/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

final class TimeSelectBottomSheetController: ASBottomSheetController {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "시간 선택"
    label.textColor = .black01
    label.font = .pretendard(.headLine3)
    return label
  }()
  
  private let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(.Icon.xmark_black, for: .normal)
    return button
  }()
  
  private let datePicker: AlarmTimePicker = {
    let datePicker = AlarmTimePicker()
    return datePicker
  }()
  
  private let bottomButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "확인"
    return button
  }()
  
  init(detents: ASBottomSheetDetent, date: Date) {
    super.init(detent: detents)
  }
  
  override func viewDidLoad() {
    configureUI()
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.layer.cornerRadius = 20
    [titleLabel, closeButton, datePicker, bottomButton].forEach {
      view.addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(20)
    }
    
    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel.snp.centerY)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    datePicker.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.3)
    }
    
    bottomButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(datePicker.snp.bottom).offset(16)
      $0.height.equalTo(52)
    }
  }
}
