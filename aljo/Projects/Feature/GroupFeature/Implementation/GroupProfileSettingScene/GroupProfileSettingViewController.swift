//
//  GroupProfileSettingViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/7/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import RxCocoa
import RxSwift
import SnapKit

final class GroupProfileSettingViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let viewModel: GroupProfileSettingViewModel
  
  private var cachedContentOffsetY: CGFloat?
  
  // MARK: Components
  private let listView: ASListView = {
    let listView = ASListView()
    listView.spacing = 28
    return listView
  }()
  
  private let groupImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .gray04
    imageView.layer.cornerRadius = 6
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = UIColor.gray02.cgColor
    imageView.clipsToBounds = true
    return imageView
  }()
  private let imageSelectButton: UIButton = {
    let button = RoundButton(style: .image)
    button.image = .Icon.picture_gray
    button.alpha = 0.9
    return button
  }()
  private let imageDetailLabel: UILabel = {
    let label = UILabel()
    label.text = "사진을 등록하지 않는 경우 랜덤 이미지로 보여집니다"
    label.textColor = .black03
    label.font = .pretendard(.caption2)
    return label
  }()
  private let imageStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    stackView.spacing = 8
    return stackView
  }()
  
  private let groupNameTextField: ASBorderHighlightTextField = {
    let textField = ASBorderHighlightTextField()
    textField.placeholder = "그룹명을 입력해주세요 (최대 30자 이내)"
    textField.maxTextCount = 30
    return textField
  }()
  
  private let groupIntroduceTextView: ASTextView = {
    let textView = ASTextView(maxLength: 50)
    textView.placeholder = "내용을 입력해주세요"
    textView.isShowCount = true
    return textView
  }()
  
  private let groupMaxCountLabel: UILabel = {
    let label = UILabel()
    label.text = "최대 8명"
    label.font = .pretendard(.caption3)
    label.textColor = .black03
    return label
  }()
  private let groupCountStepper: ASStepper = {
    let stepper = ASStepper(max: 8)
    stepper.setContentHuggingPriority(.required, for: .horizontal)
    return stepper
  }()
  private let groupCountStackView: UIStackView = {
    let stackView = UIStackView()
    let label = UILabel()
    label.text = "인원"
    label.textColor = .black01
    label.font = .pretendard(.body3)
    label.setContentHuggingPriority(.required, for: .horizontal)
    stackView.addArrangedSubview(label)
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.spacing = 4
    stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layer.borderColor = UIColor.gray02.cgColor
    stackView.layer.borderWidth = 1
    stackView.layer.cornerRadius = 6
    return stackView
  }()
  
  private let mondayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "월"
    return button
  }()
  private let tuesdayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "화"
    return button
  }()
  private let wednesdayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "수"
    return button
  }()
  private let thursdayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "목"
    return button
  }()
  private let fridayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "금"
    return button
  }()
  
  private let saturdayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "토"
    return button
  }()
  private let sundayButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "일"
    return button
  }()
  private let dayOfWeekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.distribution = .fillEqually
    stackView.spacing = 9
    return stackView
  }()
  
  private let alarmTimeTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "시간을 선택해주세요"
    textField.font = .pretendard(.body3)
    textField.isUserInteractionEnabled = false
    return textField
  }()
  private let downImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .Icon.arrow_down.withTintColor(
      .black01,
      renderingMode: .alwaysOriginal
    )
    return imageView
  }()
  private let alarmTimePickerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layer.borderColor = UIColor.gray02.cgColor
    stackView.layer.borderWidth = 1
    stackView.layer.cornerRadius = 6
    return stackView
  }()
  
  private let calendarView: ASCalendarView = {
    let calendarView = ASCalendarView(
      by: Date()...Date().addingTimeInterval(60 * 24 * 60 * 60)
    )
    return calendarView
  }()
  
  private let nextButton: ASRectButton = {
    let button = ASRectButton(style: .fill)
    button.title = "다음"
    button.isEnabled = false
    return button
  }()
  private let nextButtonBackgroundView: UIView = {
    let view = UIView()
    return view
  }()
  private let bottomGradientLayer: CAGradientLayer = {
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [
      UIColor.white.withAlphaComponent(0.1).cgColor,
      UIColor.white.cgColor
    ]
    gradientLayer.locations = [0.0, 0.2]
    return gradientLayer
  }()
  
  init(viewModel: GroupProfileSettingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    configureUI()
    bind()
    bindKeyboard()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    bottomGradientLayer.frame = nextButtonBackgroundView.bounds
    bottomGradientLayer.frame.origin.x -= 7
  }
  
  private func bind() {
    let timePickerTapGesture = UITapGestureRecognizer()
    alarmTimePickerStackView.addGestureRecognizer(timePickerTapGesture)
    let input = GroupProfileSettingViewModel.Input(
      imageSelectTapped: imageSelectButton.rx.tap,
      groupName: groupNameTextField.rx.text.orEmpty,
      groupIntroduce: groupIntroduceTextView.rx.text.orEmpty,
      headCount: groupCountStepper.rx.value,
      mondayTapped: mondayButton.rx.tap,
      tuesdayTapped: tuesdayButton.rx.tap,
      wednesdayTapped: wednesdayButton.rx.tap,
      thursdayTapped: thursdayButton.rx.tap,
      fridayTapped: fridayButton.rx.tap,
      saturdayTapped: saturdayButton.rx.tap,
      sundayTapped: sundayButton.rx.tap,
      alarmTimePickTapped: timePickerTapGesture.rx.event.map { _ in },
      endDate: calendarView.rx.selectedDate
    )
    
    let output = viewModel.transform(to: input)
    
    output.selectedImage
      .drive(groupImageView.rx.image)
      .disposed(by: disposeBag)
    
    output.isMondaySelected
      .distinctUntilChanged()
      .drive(mondayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isTuesdaySelected
      .distinctUntilChanged()
      .drive(tuesdayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isWednesdaySelected
      .distinctUntilChanged()
      .drive(wednesdayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isThursdaySelected
      .distinctUntilChanged()
      .drive(thursdayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isFridaySelected
      .distinctUntilChanged()
      .drive(fridayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isSaturdaySelected
      .distinctUntilChanged()
      .drive(saturdayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isSundaySelected
      .distinctUntilChanged()
      .drive(sundayButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.selectedDate
      .drive(alarmTimeTextField.rx.text)
      .disposed(by: disposeBag)
    
    output.toImagePicker
      .drive()
      .disposed(by: disposeBag)
    
    output.toTimePicker
      .drive()
      .disposed(by: disposeBag)
    
    output.isNextEnable
      .drive(nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
    
    output.toNext
      .drive()
      .disposed(by: disposeBag)
  }
}

// MARK: Handling Keyboard Visibility
extension GroupProfileSettingViewController {
  private func bindKeyboard() {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .withUnretained(self)
      .map { object, _ -> UIView in
        return object.groupNameTextField.isFirstResponder ?
        object.groupNameTextField : object.groupIntroduceTextView
      }
      .withUnretained(self)
      .map { object, target -> CGFloat in
        let targetMaxY = object.convertPointToMainView(
          target
        ).y + target.bounds.height
        return targetMaxY
      }
      .subscribe(with: self, onNext: { object, targetMaxY in
        object.cachedContentOffsetY = object.listView.contentOffset.y
        
        if object.nextButton.frame.minY - targetMaxY < 20 {
          let needMoveY = 40 - (object.nextButton.frame.minY - targetMaxY)
          object.listView.contentOffset.y += needMoveY
        }
        
        object.updateNextButtonLayout(bottomOffset: -20)
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .withUnretained(self)
      .compactMap { object, _ in
        object.cachedContentOffsetY
      }
      .subscribe(with: self, onNext: { object, movedContentOffsetY in
        object.listView.contentOffset.y = movedContentOffsetY
        object.updateNextButtonLayout(
          bottomOffset: -object.contentsViewKeyboardLayoutOffset()
        )
      })
      .disposed(by: disposeBag)
  }
  
  private func convertPointToMainView(_ target: UIView) -> CGPoint {
    return target.convert(listView.contentOrigin, to: view)
  }
  
  private func updateNextButtonLayout(bottomOffset: CGFloat) {
    nextButton.snp.updateConstraints {
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        .offset(bottomOffset)
    }
    
    UIView.animate(withDuration: 0.1) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: - UI Configuration
extension GroupProfileSettingViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    listView.contentInset.top = 20
    listView.contentInset.bottom = 20
    nextButtonBackgroundView.layer.addSublayer(bottomGradientLayer)
    configureHirearchy()
    configureConstraints()
  }
  
  private func configureHirearchy() {
    [listView, nextButtonBackgroundView, nextButton].forEach {
      view.addSubview($0)
    }
    
    [groupImageView, imageDetailLabel].forEach {
      imageStackView.addArrangedSubview($0)
    }
    
    listView.addSubview(imageSelectButton)
    
    [groupMaxCountLabel, groupCountStepper].forEach {
      groupCountStackView.addArrangedSubview($0)
    }
    groupMaxCountLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    groupCountStepper.setContentHuggingPriority(.required, for: .horizontal)
    
    [
      mondayButton,
      tuesdayButton,
      wednesdayButton,
      thursdayButton,
      fridayButton,
      saturdayButton,
      sundayButton
    ].forEach {
      dayOfWeekStackView.addArrangedSubview($0)
    }
    
    [alarmTimeTextField, downImage].forEach {
      alarmTimePickerStackView.addArrangedSubview($0)
    }
    downImage.setContentHuggingPriority(.required, for: .horizontal)
    alarmTimeTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    listView.addItem(imageStackView, title: "대표이미지")
    listView.addItem(groupNameTextField, title: "그룹명")
    listView.addItem(groupIntroduceTextView, title: "그룹 소개글")
    listView.addItem(groupCountStackView, title: "그룹 인원")
    listView.addSeperator()
    listView.addItem(dayOfWeekStackView, title: "알람 요일")
    listView.addItem(alarmTimePickerStackView, title: "알람 시간")
    listView.addItem(calendarView, title: "알람 종료 날짜")
  }
  
  private func configureConstraints() {
    listView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-view.frame.height * 0.09)
    }
    
    groupImageView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.29)
    }
    
    imageSelectButton.snp.makeConstraints {
      $0.trailing.equalTo(groupImageView.snp.trailing).inset(14)
      $0.bottom.equalTo(groupImageView.snp.bottom).inset(14)
    }
    
    groupNameTextField.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    groupIntroduceTextView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.16)
    }
    
    groupCountStackView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    mondayButton.snp.makeConstraints {
      $0.height.equalTo(mondayButton.snp.width)
    }
    
    alarmTimePickerStackView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    calendarView.snp.makeConstraints {
      $0.height.equalTo(calendarView.snp.width).multipliedBy(0.95)
    }
    
    nextButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        .offset(-contentsViewKeyboardLayoutOffset())
      $0.height.equalTo(view.snp.height).multipliedBy(0.065)
    }
    
    nextButtonBackgroundView.snp.makeConstraints {
      $0.top.equalTo(nextButton.snp.top).offset(-20)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
  
  private func contentsViewKeyboardLayoutOffset() -> CGFloat {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    if scene?.windows.first?.safeAreaInsets.bottom != 0 {
      return 0
    }
    
    return 20
  }
}
