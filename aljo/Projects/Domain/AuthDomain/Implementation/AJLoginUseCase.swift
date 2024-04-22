//
//  AJLoginUseCase.swift
//  AuthDomainImplementation
//
//  Created by 이태영 on 4/22/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthDataInterface
import AuthDomainInterface

import RxSwift

public final class AJLoginUseCase: LoginUseCase {
  private let authRepository: AuthRepository
  
  public init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  public func excute(with service: AuthorizationService, token: String) -> Observable<IsNewUser> {
    return authRepository.login(with: service, token: token).map { _ in true }
  }
}
