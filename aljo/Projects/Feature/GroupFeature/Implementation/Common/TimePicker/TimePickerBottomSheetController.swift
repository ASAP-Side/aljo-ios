//
//  TimePickerBottomSheetController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/10/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

public protocol TimePickerBottomSheetDelegate: AnyObject {
  func timePickerBottomSheet(
    _ controller: TimePickerBottomSheetController,
    didComplete date: Date?
  )
}

public final class TimePickerBottomSheetController: ASBottomSheetController {
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
  
  private let timePicker: AlarmTimePicker
  
  private let confirmButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "확인"
    return button
  }()
  
  public weak var delegate: TimePickerBottomSheetDelegate?
  
  init(detents: ASBottomSheetDetent, date: Date) {
    self.timePicker = AlarmTimePicker(startDate: date)
    super.init(detent: detents)
  }
  
  override public func viewDidLoad() {
    configreAction()
    configureUI()
  }
  
  private func configreAction() {
    let confirmAction = UIAction { [weak self] _ in
      guard let self = self else {
        return
      }
      self.delegate?.timePickerBottomSheet(self, didComplete: self.timePicker.selectedDate)
      self.dismiss(animated: true)
    }
    
    let closeAction = UIAction { [weak self] _ in
      self?.dismiss(animated: true)
    }
    
    confirmButton.addAction(confirmAction, for: .touchUpInside)
    closeButton.addAction(closeAction, for: .touchUpInside)
  }
  
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.layer.cornerRadius = 20
    [titleLabel, closeButton, timePicker, confirmButton].forEach {
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
    
    timePicker.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(24)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.3)
    }
    
    confirmButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.top.equalTo(timePicker.snp.bottom).offset(16)
      $0.height.equalToSuperview().multipliedBy(0.065)
    }
  }
}
