//
//  LoginViewModel.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface
import AuthDomainInterface

import RxSwift
import RxCocoa

public final class LoginViewModel: ViewModelable {
  enum NextPage {
    case home
    case basicSetting
    case errorAlert
  }
  
  public struct Input {
    let appleSignInTap: ControlEvent<Void>
    let kakaoSignInTap: ControlEvent<Void>
  }
  
  public struct Output {
    let isLoggingIn: Driver<Bool>
    let logginComplete: Driver<Void>
  }
  
  private let authorizationManager: AuthorizationManager
  private let loginUseCase: LoginUseCase
  
  public init(
    authorizationManager: AuthorizationManager,
    loginUseCase: LoginUseCase
  ) {
    self.authorizationManager = authorizationManager
    self.loginUseCase = loginUseCase
  }
  
  public func transform(to input: Input) -> Output {
    let appleToken = input.appleSignInTap
      .flatMap {
        return self.authorizationManager.signInWithApple()
      }
      .map { user -> (AuthorizationService, String) in
        return (.apple, user)
      }
    
    let kakaoToken = input.kakaoSignInTap
      .flatMap {
        return self.authorizationManager.signInWithKakao()
      }
      .map { token -> (AuthorizationService, String) in
        return (.kakao, token)
      }
    
    let authorization = Observable.merge(appleToken, kakaoToken)
      .share()
      .debug()
    
    let logginSuccess = authorization.flatMap { (service, token) in
      return self.loginUseCase.excute(with: service, token: token)
    }
      .map { $0 ? .basicSetting : .home }
      .catch({ _ in
        return .just(.errorAlert)
      })
      .do { nextPage in
        self.requestToCoordinator(to: nextPage)
      }
      .map { _ in }
    
    let isLoggingIn = Observable.from([
      authorization.map { _ in true },
      logginSuccess.map { _ in false }
    ])
      .merge()
    
    return Output(
      isLoggingIn: isLoggingIn.asDriver(onErrorJustReturn: false),
      logginComplete: logginSuccess.asDriver(onErrorJustReturn: ())
    )
  }
  
  private func requestToCoordinator(to next: NextPage) {
    // TODO: 화면 전환
  }
}
