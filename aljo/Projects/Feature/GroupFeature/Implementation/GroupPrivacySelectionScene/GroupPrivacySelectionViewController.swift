//
//  GroupPrivacySelectionViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import RxCocoa
import RxSwift
import SnapKit

final class GroupPrivacySelectionViewController: UIViewController {
  private let viewModel: GroupPrivacySelectionViewModel
  private let disposeBag = DisposeBag()
  // MARK: Components
  private let contentsView: UIView = {
    let view = UIView()
    view.clipsToBounds = true
    return view
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

  private let publicButton = PrivacyButton(
    image: .Icon.public,
    title: "공개"
  )
  
  private let privateButton = PrivacyButton(
    image: .Icon.private,
    title: "비공개"
  )
  
  private let passwordTextFieldTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.caption2)
    label.textColor = .black03
    return label
  }()
  
  private let passwordTextField: ASUnderBarTextField = {
    let textField = ASUnderBarTextField()
    textField.placeHolder = "비밀번호 4자리를 입력해주세요"
    textField.maxTextCount = 4
    textField.isHidden = true
    return textField
  }()
  
  private let nextButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "다음"
    button.isEnabled = false
    return button
  }()
  
  init(viewModel: GroupPrivacySelectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    navigationController?.navigationBar.backgroundColor = .systemBackground
    configureUI()
    bind(with: viewModel)
    bindKeyboard()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  private func bind(with viewModel: GroupPrivacySelectionViewModel) {
    let input = GroupPrivacySelectionViewModel.Input(
      publicTapped: publicButton.rx.tap,
      privateTapped: privateButton.rx.tap,
      password: passwordTextField.rx.text.orEmpty,
      nextButtonTapped: nextButton.rx.tap
    )
    
    let output = viewModel.transform(to: input)
    
    output.isPublicSelected
      .drive(publicButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isPublicSelected
      .drive(passwordTextField.rx.isHidden)
      .disposed(by: disposeBag)
    
    output.isPublicSelected
      .map { _ in "" }
      .drive(passwordTextField.rx.text)
      .disposed(by: disposeBag)
    
    output.isPrivateSelected
      .drive(privateButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.passwordTitle
      .drive(passwordTextFieldTitleLabel.rx.text)
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
extension GroupPrivacySelectionViewController {
  private func bindKeyboard() {
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillShowNotification)
      .withUnretained(self)
      .map { (object, _) -> CGFloat in
        return 20 - (object.nextButton.frame.minY - object.passwordTextField.frame.maxY)
      }
      .subscribe(with: self, onNext: { object, needMoveY in
        if object.nextButton.frame.minY - object.passwordTextField.frame.maxY < 20 {
          object.titleLabel.snp.updateConstraints {
            $0.top.equalToSuperview().offset(-needMoveY)
          }
        }
        
        object.updateNextButtonLayout(bottomOffset: -20)
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .withUnretained(self)
      .subscribe(with: self, onNext: { object, _ in
        object.titleLabel.snp.updateConstraints {
          $0.top.equalToSuperview().offset(20)
        }
        
        object.updateNextButtonLayout(
          bottomOffset: -object.contentsViewKeyboardLayoutOffset()
        )
      })
      .disposed(by: disposeBag)
    
    //  키보드가 올라와있는 상태에서 publicButton이 탭됐을 때 예외 처리
    publicButton.rx.tap
      .subscribe(with: self, onNext: { object, _ in
        object.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateNextButtonLayout(bottomOffset: CGFloat) {
    nextButton.snp.updateConstraints {
      $0.bottom.equalTo(contentsView.keyboardLayoutGuide.snp.top)
        .offset(bottomOffset)
    }
    
    UIView.animate(withDuration: 0.1) {
      self.view.layoutIfNeeded()
    }
  }
}

// MARK: Configure UI
extension GroupPrivacySelectionViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.clipsToBounds = true
    
    if #available(iOS 17.0, *) {
      view.keyboardLayoutGuide.usesBottomSafeArea = false
    }
    
    configureHirearchy()
    configureConstraints()
  }
  
  private func configureHirearchy() {
    [
      contentsView
    ].forEach {
      view.addSubview($0)
    }
    
    [
      titleLabel,
      subTitleLabel,
      publicButton,
      privateButton,
      passwordTextFieldTitleLabel,
      passwordTextField,
      nextButton
    ]
      .forEach {
        contentsView.addSubview($0)
      }
  }
  
  private func configureConstraints() {
    contentsView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      $0.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
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
      $0.height.equalToSuperview().multipliedBy(0.085)
    }
    
    privateButton.snp.makeConstraints {
      $0.top.equalTo(publicButton.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.085)
    }
    
    passwordTextFieldTitleLabel.snp.makeConstraints {
      $0.top.equalTo(privateButton.snp.bottom).offset(30)
      $0.leading.equalToSuperview().offset(20)
    }
    
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(privateButton.snp.bottom).offset(54)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    nextButton.snp.makeConstraints {
      $0.bottom.equalTo(contentsView.keyboardLayoutGuide.snp.top)
        .offset(-contentsViewKeyboardLayoutOffset())
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalTo(view.snp.height).multipliedBy(0.065)
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
