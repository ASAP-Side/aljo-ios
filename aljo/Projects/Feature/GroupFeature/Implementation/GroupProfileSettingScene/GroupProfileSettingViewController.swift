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
  
  // MARK: Components
  private let listView: ASListView = {
    let listView = ASListView()
    listView.spacing = 28
    return listView
  }()
  
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .gray04
    return imageView
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
    textField.placeholder = "그룹명을 입력해주세요 (최대 15자 이내)"
    return textField
  }()
  
  private let groupIntroduceTextView: ASTextView = {
    let textView = ASTextView(placeholder: "내용을 입력해주세요", maxLength: 50)
    textView.borderColor = .black04
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
  
  private let timeTextField: UITextField = {
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
  private let timePickerStackView: UIStackView = {
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
    let calendarView = ASCalendarView()
    return calendarView
  }()
  
  private let nextButton: ASRectButton = {
    let button = ASRectButton(style: .fill)
    button.title = "다음"
    return button
  }()
  
  override func viewDidLoad() {
    configureUI()
  }
}

// MARK: - UI Configuration
extension GroupProfileSettingViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    listView.contentInset = UIEdgeInsets(
      top: 20,
      left: 0,
      bottom: view.frame.height * 0.13,
      right: 0
    )
    configureHirearchy()
    configureConstraints()
  }
  
  private func configureHirearchy() {
    view.addSubview(listView)
    listView.addSubview(nextButton)
    
    [imageView, imageDetailLabel].forEach {
      imageStackView.addArrangedSubview($0)
    }
    
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
    
    [timeTextField, downImage].forEach {
      timePickerStackView.addArrangedSubview($0)
    }
    downImage.setContentHuggingPriority(.required, for: .horizontal)
    timeTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
    
    listView.addItem(imageStackView, title: "대표이미지")
    listView.addItem(groupNameTextField, title: "그룹명")
    listView.addItem(groupIntroduceTextView, title: "그룹 소개글")
    listView.addItem(groupCountStackView, title: "그룹 인원")
    listView.addSeperator()
    listView.addItem(dayOfWeekStackView, title: "알람 요일")
    listView.addItem(timePickerStackView, title: "알람 시간")
    listView.addItem(calendarView, title: "알람 종료 날짜")
  }
  
  private func configureConstraints() {
    listView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    
    imageView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.29)
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
    
    timePickerStackView.snp.makeConstraints {
      $0.height.equalTo(view.snp.height).multipliedBy(0.06)
    }
    
    calendarView.snp.makeConstraints {
      $0.height.equalTo(calendarView.snp.width).multipliedBy(0.95)
    }
    
    nextButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalTo(listView.keyboardLayoutGuide.snp.top)
        .offset(-contentsViewKeyboardLayoutOffset())
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
