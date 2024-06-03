//
//  AlarmInteractionSettingViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/14/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import RxSwift
import RxCocoa
import SnapKit

final class AlarmInteractionSettingViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let viewModel: AlarmInteractionSettingViewModel
  
  // MARK: Components
  private let titleLabel: UILabel = {
    let label = UILabel()
    // TODO: 닉네임 동적으로 변경
    label.text = "아삽아삽님만의 알람 방식을\n선택해주세요!"
    label.textColor = .black01
    label.font = .pretendard(.headLine1)
    label.numberOfLines = 0
    return label
  }()
  
  private let listView: ASListView = {
    let listView = ASListView()
    listView.spacing = 28
    return listView
  }()
  
  private let soundOnlyButton: UIButton = {
    let button = ASRectButton(style: .stroke)
    button.title = "소리"
    return button
  }()
  private let vibrateOnlyButton: UIButton = {
    let button = ASRectButton(style: .stroke)
    button.title = "진동"
    return button
  }()
  private let soundAndVibrateButton: UIButton = {
    let button = ASRectButton(style: .stroke)
    button.title = "소리, 진동"
    return button
  }()
  private let interactionButtonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 8
    return stackView
  }()
  
  private let musicNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black03
    label.text = "안녕하세요"
    label.font = .pretendard(.body4)
    return label
  }()
  private let disclosureImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .Icon.arrow_right
    return imageView
  }()
  private let musicSelectStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 4
    stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layer.borderColor = UIColor.gray02.cgColor
    stackView.layer.borderWidth = 1
    stackView.layer.cornerRadius = 6
    let label = UILabel()
    label.text = "노래 선택"
    label.textColor = .black01
    label.font = .pretendard(.body3)
    stackView.addArrangedSubview(label)
    return stackView
  }()
  
  private let volumeSliderDescriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "최저 음량 10 이상부터 설정이 가능합니다."
    label.textColor = .black03
    label.font = .pretendard(.caption2)
    return label
  }()
  private let volumeSlider: ASSlider = {
    let slider = ASSlider()
    slider.backgroundTintColor = .clear
    slider.rightTintColor = .gray03
    slider.leftTintColor = .red01
    slider.rightImage = .Icon.sound
    slider.leftImage = .Icon.mute
    slider.value = 0.1
    return slider
  }()
  private let volumeSliderStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 20
    return stackView
  }()
  
  private let confirmButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "확인"
    button.isEnabled = false
    return button
  }()

  init(viewModel: AlarmInteractionSettingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    configureUI()
    bind()
  }
  
  private func bind() {
    let input = AlarmInteractionSettingViewModel.Input(
      soundOnlyTapped: soundOnlyButton.rx.tap,
      vibrateOnlyTapped: vibrateOnlyButton.rx.tap,
      soundAndVibrateTapped: soundAndVibrateButton.rx.tap,
      volume: volumeSlider.rx.value
    )
    
    let output = viewModel.transform(to: input)
    
    output.isSoundOnlySelected
      .drive(soundOnlyButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isVibrateOnlySelected
      .drive(vibrateOnlyButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isSoundAndVibrateSelected
      .drive(soundAndVibrateButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isSoundSettingHidden
      .startWith(true)
      .drive(
        listView.contentViews[1].rx.isHidden,
        listView.contentViews[2].rx.isHidden
      )
      .disposed(by: disposeBag)
    
    output.isConfirmEnable
      .drive(confirmButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

// MARK: Configure UI
extension AlarmInteractionSettingViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    configureHierarchy()
    configureConstraints()
  }
  
  private func configureHierarchy() {
    [
      titleLabel,
      listView,
      confirmButton
    ].forEach {
      view.addSubview($0)
    }
    
    [soundOnlyButton, vibrateOnlyButton, soundAndVibrateButton].forEach {
      interactionButtonStackView.addArrangedSubview($0)
    }
    
    [musicNameLabel, disclosureImage].forEach {
      musicSelectStackView.addArrangedSubview($0)
    }
    
    [volumeSliderDescriptionLabel, volumeSlider].forEach {
      volumeSliderStackView.addArrangedSubview($0)
    }
    
    listView.addItem(interactionButtonStackView, title: "알람 방식")
    listView.addItem(musicSelectStackView, title: "알림음")
    listView.addItem(volumeSliderStackView, title: "음량")
  }
  
  private func configureConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    
    listView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
    
    interactionButtonStackView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    musicSelectStackView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    volumeSlider.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.03)
    }
    
    confirmButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        .inset(safeAreaBottomInset())
      $0.height.equalTo(view.snp.height).multipliedBy(0.065)
    }
  }
  
  private func safeAreaBottomInset() -> CGFloat {
      let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
      if scene?.windows.first?.safeAreaInsets.bottom == 0 {
        return 20
      }
      
      return .zero
    }
}
