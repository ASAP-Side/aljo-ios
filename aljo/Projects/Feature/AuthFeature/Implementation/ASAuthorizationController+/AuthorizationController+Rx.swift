//
//  AuthorizationController+Rx.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthenticationServices

import RxCocoa
import RxSwift

extension Reactive where Base: ASAuthorizationController {
  var delegate: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
    return RxASAuthorizationControllerProxy.proxy(for: self.base)
  }
  
  var didCompleteAuthorization: Observable<String> {
    delegate.methodInvoked(
      #selector(
        ASAuthorizationControllerDelegate
          .authorizationController(controller:didCompleteWithAuthorization:)
      )
    )
    .compactMap { $0[1] as? ASAuthorization }
    .compactMap { $0.credential as? ASAuthorizationAppleIDCredential }
    .map { $0.user }
  }
}
