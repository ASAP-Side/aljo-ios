//
//  AJAuthRepository.swift
//  AuthDataImplementation
//
//  Created by 이태영 on 4/22/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthDataInterface
import AuthDomainInterface
import AJNetworkInterface

import RxSwift

public final class AJAuthRepository: AuthRepository {
  private let networkProvider: Provider
  
  init(networkProvider: Provider) {
    self.networkProvider = networkProvider
  }
  
  public func login(with service: AuthorizationService, token: String) -> Observable<Void> {
    let router: LoginRouter
    
    switch service {
    case .apple:
      let user = AppleUser(user: token)
      router = .loginWithApple(user: user)
    case .kakao:
      let token = KakaoAccessToken(kakaoAccessToken: token)
      router = .loginWithKakao(token: token)
    }
    
    return networkProvider.data(router).map { _ in }
  }
}
