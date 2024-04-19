//
//  StubLoginUseCase.swift
//  AuthDomainTesting
//
//  Created by 이태영 on 4/19/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthDomainInterface

import RxSwift

public final class StubLoginUseCase: LoginUseCase {
  public func excute(
    with service: AuthorizationService,
    token: String
  ) -> Observable<IsNewUser> {
    Observable.create { observer in
      observer.onNext(true)
      observer.onCompleted()
      return Disposables.create { }
    }
  }
  
  public init() {
    
  }
}
