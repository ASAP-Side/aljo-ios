//
//  ASAlarmSettingView.swift
//  ASAPKit
//
//  Created by Wonbi on 5/19/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

public final class ASAlarmSettingView: UIView {
  // MARK: - Public Property
  public enum AlarmStyle {
    case sound
    case vibration
    case both
  }
  /// 타이틀에 들어가는 유저의 이름입니다.
  public var titleName: String = "" {
    didSet {
      titleLabel.text = "\(titleName)님의 알람 방식을\n선택해주세요!"
    }
  }
  
  // MARK: - Private Property
  @objc fileprivate var _selectedAlarmTitle: String = "" {
    didSet {
      selectedAlarmLabel.text = _selectedAlarmTitle
    }
  }
  
  private let disposeBag = DisposeBag()
  
  fileprivate let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.headLine1)
    label.textColor = .black01
    label.numberOfLines = 0
    return label
  }()
  
  private let alramStyleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    return stackView
  }()
  
  private let alarmStyleLabel: UILabel = {
    let label = UILabel()
    label.text = "알람 방식"
    label.font = .pretendard(.body5)
    label.textColor = .black02
    return label
  }()
  
  fileprivate let soundButton: ASRectButton = {
    let button =  ASRectButton(style: .stroke)
    button.title = "소리"
    button.isSelected = true
    return button
  }()
  
  fileprivate let vibrationButton: ASRectButton = {
    let button =  ASRectButton(style: .stroke)
    button.title = "진동"
    return button
  }()
  
  fileprivate let soundVibrationButton: ASRectButton = {
    let button =  ASRectButton(style: .stroke)
    button.title = "소리,진동"
    return button
  }()
  
  private let alarmSoundLabel: UILabel = {
    let label = UILabel()
    label.text = "알람음"
    label.font = .pretendard(.body5)
    label.textColor = .black02
    return label
  }()
  
  fileprivate let musicSelectButton: ASRectButton = {
    let button =  ASRectButton(
      style: .strokeImage(
        padding: .dynamic,
        placement: .trailing,
        contentInsets: .init(
          top: 0,
          leading: 16,
          bottom: 0,
          trailing: 16)
      )
    )
    button.image = .Icon.arrow_right
    button.title = "노래 선택"
    return button
  }()
  
  private let selectedAlarmLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .right
    label.font = .pretendard(.body4)
    label.textColor = .black03
    return label
  }()
  
  private let alarmVolumeLabel: UILabel = {
    let label = UILabel()
    label.text = "음량"
    label.font = .pretendard(.body5)
    label.textColor = .black02
    return label
  }()
  
  private let volumeCaptionLabel: UILabel = {
    let label = UILabel()
    label.text = "최저 음량 10 이상부터 설정이 가능합니다."
    label.font = .pretendard(.caption2)
    label.textColor = .black03
    return label
  }()
  
  fileprivate let volumeSlider: ASSlider = {
    let slider = ASSlider()
    slider.tintColor = .red01
    slider.leftImage = .Icon.mute
    slider.rightImage = .Icon.sound
    slider.leftTintColor = .red01
    slider.rightTintColor = .gray03
    return slider
  }()
  
  // MARK: - Initialize
  public init() {
    super.init(frame: .zero)
    
    configureUI()
    configureLayout()
    bind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Method
  private func configureUI() {
    backgroundColor = .white
    
    [soundButton, vibrationButton, soundVibrationButton]
      .forEach(alramStyleStackView.addArrangedSubview)
    
    [
      titleLabel,
      alarmStyleLabel,
      alramStyleStackView,
      alarmSoundLabel,
      musicSelectButton,
      selectedAlarmLabel,
      alarmVolumeLabel,
      volumeCaptionLabel,
      volumeSlider
    ]
      .forEach(addSubview)
  }
  
  private func configureLayout() {
    titleLabel.snp.makeConstraints { make in
      make.top.leading.equalToSuperview()
    }
    
    alarmStyleLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(30)
      make.leading.equalToSuperview()
    }
    
    alramStyleStackView.snp.makeConstraints { make in
      make.top.equalTo(alarmStyleLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview()
    }
    
    [soundButton, vibrationButton, soundVibrationButton].forEach { button in
      button.snp.makeConstraints { make in
        make.height.equalTo(48)
      }
    }
    
    alarmSoundLabel.snp.makeConstraints { make in
      make.top.equalTo(alramStyleStackView.snp.bottom).offset(30)
      make.leading.equalToSuperview()
    }
    
    musicSelectButton.snp.makeConstraints { make in
      make.top.equalTo(alarmSoundLabel.snp.bottom).offset(8)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(48)
    }
    
    selectedAlarmLabel.snp.makeConstraints { make in
      make.centerY.equalTo(musicSelectButton)
      make.leading.equalTo(self.snp.centerX).offset(10)
      make.trailing.equalTo(musicSelectButton.snp.trailing).inset(35)
    }
    
    alarmVolumeLabel.snp.makeConstraints { make in
      make.top.equalTo(musicSelectButton.snp.bottom).offset(30)
      make.leading.equalToSuperview()
    }
    
    volumeCaptionLabel.snp.makeConstraints { make in
      make.top.equalTo(alarmVolumeLabel.snp.bottom).offset(4)
      make.leading.equalToSuperview()
    }
    
    volumeSlider.snp.makeConstraints { make in
      make.top.equalTo(volumeCaptionLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
    }
  }
  
  private func bind() {
    let buttons = [soundButton, vibrationButton, soundVibrationButton]
    
    buttons.forEach { button in
      button.rx.tap
        .bind { _ in
          buttons
            .filter { $0 != button }
            .forEach { $0.isSelected = false }
          button.isSelected = true
        }
        .disposed(by: disposeBag)
    }
    
    self.rx.selectedAlarmStyle
      .bind(with: self) { owner, style in
        let isHidden = style == .vibration
          owner.alarmSoundLabel.isHidden = isHidden
          owner.musicSelectButton.isHidden = isHidden
          owner.selectedAlarmLabel.isHidden = isHidden
          owner.alarmVolumeLabel.isHidden = isHidden
          owner.volumeCaptionLabel.isHidden = isHidden
          owner.volumeSlider.isHidden = isHidden
      }
      .disposed(by: disposeBag)
  }
}

// MARK: - Reactive Extension
public extension Reactive where Base: ASAlarmSettingView {
  /// 타이틀에 들어가는 유저의 이름입니다.
  var titleName: Binder<String> {
    Binder<String>(self.base) { view, value in
      view.titleLabel.text = "\(value)님의 알람 방식을\n선택해주세요!"
    }
  }
  
  /// 사용자가 선택한 알람 스타일입니다.
  var selectedAlarmStyle: ControlEvent<ASAlarmSettingView.AlarmStyle> {
    let soundTapped = self.base.soundButton.rx.tap
      .map { _ in
        ASAlarmSettingView.AlarmStyle.sound
      }
    
    let vibrationTapped = self.base.vibrationButton.rx.tap
      .map { _ in
        ASAlarmSettingView.AlarmStyle.vibration
      }
    
    let soundVibrationTapped = self.base.soundVibrationButton.rx.tap
      .map { _ in
        ASAlarmSettingView.AlarmStyle.both
      }
    
    let events = Observable<ASAlarmSettingView.AlarmStyle>.merge(soundTapped,
                                                               vibrationTapped,
                                                               soundVibrationTapped)
      .startWith(.sound)
    
    return ControlEvent(events: events)
  }
  
  /// 사용자가 노래 선택을 터치했음을 알립니다.
  var tapSelectMusic: ControlEvent<Void> {
    self.base.musicSelectButton.rx.tap
  }
 
  /// 사용자가 선택한 노래 제목입니다.
  var selectedAlarmTitle: ControlProperty<String> {
    let values = self.base.rx.methodInvoked(#selector(setter: self.base._selectedAlarmTitle))
      .compactMap { $0.first as? String }
      .share()
    
    let valueSink = Binder<String>(self.base) { view, value in
      view._selectedAlarmTitle = value
    }
    
    return ControlProperty<String>(values: values, valueSink: valueSink)
  }
  
  /// 알람 볼륨 레벨입니다.
  var volumeLevel: ControlProperty<Float> {
    self.base.volumeSlider.rx.value
  }
}
