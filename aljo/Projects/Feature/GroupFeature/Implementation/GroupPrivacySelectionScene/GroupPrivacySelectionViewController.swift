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

public final class GroupPrivacySelectionViewController: UIViewController {
  private let viewModel: GroupPrivacySelectionViewModel
  private let disposeBag = DisposeBag()
  // MARK: Components
  private let stepProgressView: UIProgressView = {
    let progressView = UIProgressView()
    progressView.progressTintColor = .red01
    progressView.trackTintColor = .gray01
    progressView.progress = 0.5
    return progressView
  }()
  
  private let contentsScrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.contentInset.top = 20
    return scrollView
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
  
  // TODO: 이미지 변경
  private let publicButton = PrivacyButton(
    image: .Icon.arrow_circle,
    title: "공개"
  )
  
  private let privateButton = PrivacyButton(
    image: .Icon.arrow_circle,
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
  
  public init(viewModel: GroupPrivacySelectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    navigationController?.navigationBar.backgroundColor = .systemBackground
    configureUI()
    bind(with: viewModel)
    bindKeyboard()
  }
  
  private func bind(with viewModel: GroupPrivacySelectionViewModel) {
    let input = GroupPrivacySelectionViewModel.Input(
      tapPublic: publicButton.rx.tap,
      tapPrivate: privateButton.rx.tap,
      password: passwordTextField.rx.text.orEmpty
    )
    
    let output = viewModel.transform(to: input)
    
    output.isPublicSelected
      .drive(publicButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isPrivateSelected
      .drive(privateButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isPublicSelected
      .drive(passwordTextField.rx.isHidden)
      .disposed(by: disposeBag)
    
    output.passwordTitle
      .drive(passwordTextFieldTitleLabel.rx.text)
      .disposed(by: disposeBag)
    
    output.isNextEnable
      .drive(nextButton.rx.isEnabled)
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
          object.contentsScrollView.setContentOffset(CGPoint(x: 0, y: needMoveY), animated: true)
        }
        
        object.updateNextButtonLayout(
          bottomOffset: -20
        )
      })
      .disposed(by: disposeBag)
    
    NotificationCenter.default.rx
      .notification(UIResponder.keyboardWillHideNotification)
      .withUnretained(self)
      .subscribe(with: self, onNext: { object, _ in
        object.contentsScrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
        
        object.updateNextButtonLayout(
          bottomOffset: -object.scrollViewKeyboardLayoutOffset()
        )
      })
      .disposed(by: disposeBag)
    
    // 키보드가 올라와있는 상태에서 publicButton이 탭됐을 때 예외 처리
    publicButton.rx.tap
      .subscribe(with: self, onNext: { object, _ in
        object.view.endEditing(true)
      })
      .disposed(by: disposeBag)
    
    let tapGesture = UITapGestureRecognizer()
    tapGesture.cancelsTouchesInView = false
    contentsScrollView.addGestureRecognizer(tapGesture)
    
    tapGesture.rx.event
      .subscribe(with: self, onNext: { object, _ in
        object.view.endEditing(true)
      })
      .disposed(by: disposeBag)
  }
  
  private func updateNextButtonLayout(bottomOffset: CGFloat) {
    nextButton.snp.updateConstraints {
      $0.bottom.equalTo(contentsScrollView.keyboardLayoutGuide.snp.top)
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
      stepProgressView,
      contentsScrollView
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
        contentsScrollView.addSubview($0)
      }
  }
  
  private func configureConstraints() {
    stepProgressView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(2)
    }
    
    contentsScrollView.snp.makeConstraints {
      $0.top.equalTo(stepProgressView.snp.top)
      $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
      $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
      $0.bottom.equalToSuperview()
      $0.width.equalTo(contentsScrollView.contentLayoutGuide.snp.width)
      $0.height.equalTo(contentsScrollView.contentLayoutGuide.snp.height)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(contentsScrollView.contentLayoutGuide.snp.top)
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
    }
    
    privateButton.snp.makeConstraints {
      $0.top.equalTo(publicButton.snp.bottom).offset(8)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
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
      $0.bottom.equalTo(contentsScrollView.keyboardLayoutGuide.snp.top)
        .offset(-scrollViewKeyboardLayoutOffset())
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.065)
    }
  }
  
  private func scrollViewKeyboardLayoutOffset() -> CGFloat {
    let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
    if scene?.windows.first?.safeAreaInsets.bottom != 0 {
      return 0
    }
    
    return 20
  }
}
