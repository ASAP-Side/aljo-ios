//
//  LoginViewController.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/1/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import UIKit

import ASAPKit

import RxSwift
import RxCocoa
import SnapKit

public final class LoginViewController: UIViewController {
  private let kakaoColor = UIColor(red: 254/255, green: 228/255, blue: 0, alpha: 1)
  
  private let disposeBag = DisposeBag()
  private let viewModel: LoginViewModel
  
  private let appleLoginButton = UIButton()
  private let kakaoLoginButton = UIButton()
  private let activityIndicator = UIActivityIndicatorView()
  
  public init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    configureUI()
    bind()
  }
  
  private func bind() {
    let input = LoginViewModel.Input(
      appleLoginTap: appleLoginButton.rx.tap,
      kakaoLoginTap: kakaoLoginButton.rx.tap
    )
    
    let output = viewModel.transform(to: input)
    
    output.isLoggingIn
      .drive(activityIndicator.rx.isAnimating)
      .disposed(by: disposeBag)
    
    output.logginComplete
      .drive()
      .disposed(by: disposeBag)
  }
}

// MARK: Configure UI
extension LoginViewController {
  private func configureUI() {
    configureHierarchy()
    configureConstraints()
    view.backgroundColor = .systemBackground
    
    appleLoginButton.configuration = makeLoginButtonConfiguration(
      title: "Apple로 시작하기",
      image: .Icon.apple,
      backgroundColor: .black01,
      foregroundColor: ASAPKitAsset.Gray.white.color
    )
    
    kakaoLoginButton.configuration = makeLoginButtonConfiguration(
      title: "카카오로 시작하기",
      image: .Icon.kakao,
      backgroundColor: kakaoColor,
      foregroundColor: .black01
    )
  }
  
  private func configureHierarchy() {
    [appleLoginButton, kakaoLoginButton, activityIndicator].forEach {
      view.addSubview($0)
    }
  }
  
  private func configureConstraints() {
    appleLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-30)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.bottom.equalTo(appleLoginButton.snp.top).offset(-10)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    activityIndicator.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
  }
  
  private func makeLoginButtonConfiguration(
    title: String,
    image: UIImage,
    backgroundColor: UIColor,
    foregroundColor: UIColor
  ) -> UIButton.Configuration {
    var configuration = UIButton.Configuration.plain()
    var titleContainer = AttributeContainer()
    titleContainer.font = .pretendard(.body2)
    titleContainer.foregroundColor = foregroundColor
    configuration.attributedTitle = AttributedString(title, attributes: titleContainer)
    configuration.image = image
    configuration.imagePlacement = .leading
    configuration.imagePadding = 64
    configuration.background.backgroundColor = backgroundColor
    configuration.background.cornerRadius = 8
    configuration.contentInsets = .init(top: 14, leading: 20, bottom: 14, trailing: 102)
    return configuration
  }
}
