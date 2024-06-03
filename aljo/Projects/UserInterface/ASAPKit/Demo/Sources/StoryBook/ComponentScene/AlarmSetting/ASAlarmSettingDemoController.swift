//
//  ASAlarmSettingDemoViewController.swift
//  ASAPKit
//
//  Created by Wonbi on 5/20/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

import ASAPKit

final class ASAlarmSettingDemoController: ComponentViewController {
  private let alarmSettingView: ASAlarmSettingView = ASAlarmSettingView()
  
  private let textField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "사용자 이름"
    return textField
  }()
  
  private let alarmTitleTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "노래 이름"
    return textField
  }()
  
  private let styleLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let tapLabel: UILabel = {
    let label = UILabel()
    label.text = ""
    return label
  }()
  
  private let volumeLabel: UILabel = {
    let label = UILabel()
    return label
  }()
  
  private let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addSampleView(to: textField) { make in
      make.top.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    addSampleView(to: alarmTitleTextField) { make in
      make.top.equalTo(self.textField.snp.bottom).offset(10)
      make.leading.trailing.equalToSuperview().inset(20)
    }
    
    addSampleView(to: alarmSettingView) { make in
      make.top.equalTo(self.alarmTitleTextField.snp.bottom).offset(20)
      make.leading.trailing.bottom.equalToSuperview().inset(20)
    }
    
    addSampleView(to: styleLabel) { make in
      make.leading.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(110)
    }
    
    addSampleView(to: tapLabel) { make in
      make.leading.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(80)
    }
    
    addSampleView(to: volumeLabel) { make in
      make.leading.equalToSuperview().inset(20)
      make.bottom.equalToSuperview().inset(50)
    }
    
    bind()
  }
  
  private func bind() {
    textField.rx.text.orEmpty
      .bind(to: alarmSettingView.rx.titleName)
      .disposed(by: disposeBag)
    
    alarmTitleTextField.rx.text.orEmpty
      .bind(to: alarmSettingView.rx.selectedAlarmTitle)
      .disposed(by: disposeBag)
    
    alarmSettingView.rx.selectedAlarmStyle
      .map { style in
        switch style {
        case .sound:
          return "소리"
        case .vibration:
          return "진동"
        case .both:
          return "소리,진동"
        }
      }
      .map { style in
        "선택한 알람 방식: \(style)"
      }
      .bind(to: styleLabel.rx.text)
      .disposed(by: disposeBag)
    
    alarmSettingView.rx.tapSelectMusic
      .withUnretained(tapLabel)
      .map { label, _ in
        return label.text!.isEmpty ? "노래 선택 탭!" : ""
      }
      .bind(to: tapLabel.rx.text)
      .disposed(by: disposeBag)
    
    alarmSettingView.rx.volumeLevel
      .map { level in
        "현재 볼륨: \(level)"
      }
      .bind(to: volumeLabel.rx.text)
      .disposed(by: disposeBag)
  }
}
