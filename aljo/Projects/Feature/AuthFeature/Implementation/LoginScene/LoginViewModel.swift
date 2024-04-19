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
  public struct Input {
    let appleSignInTap: ControlEvent<Void>
    let kakaoSignInTap: ControlEvent<Void>
  }
  
  public struct Output {
    let isLoggingIn: Driver<Bool>
    let logginSuccess: Driver<Void>
  }
  
  private let authorizationManager: AuthorizationManager
  private let loginUseCase: LoginUseCase
  
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
    
    let logginSuccess = authorization.flatMap { (service, token) in
      return self.loginUseCase.excute(with: service, token: token)
    }
      .do { _ in
        // TODO: 화면전환
      }
      .map { _ in }
    
    let isLoggingIn = Observable.from([
      authorization.map { _ in true },
      logginSuccess.map { _ in false }
    ])
      .merge()
    
    return Output(
      isLoggingIn: isLoggingIn.asDriver(onErrorJustReturn: false),
      logginSuccess: logginSuccess.asDriver(onErrorJustReturn: ())
    )
  }
  
  public init(
    authorizationManager: AuthorizationManager,
    loginUseCase: LoginUseCase
  ) {
    self.authorizationManager = authorizationManager
    self.loginUseCase = loginUseCase
  }
}
