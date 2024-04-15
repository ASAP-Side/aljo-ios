//
//  RxASAuthorizationControllerProxy.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthenticationServices

import RxCocoa

final class RxASAuthorizationControllerProxy
: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType {
  static func registerKnownImplementations() {
    self.register {  (authorizationController) -> RxASAuthorizationControllerProxy in
      RxASAuthorizationControllerProxy(
        parentObject: authorizationController,
        delegateProxy: self
      )
    }
  }
  
  static func currentDelegate(
    for object: ASAuthorizationController
  ) -> ASAuthorizationControllerDelegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(
    _ delegate: ASAuthorizationControllerDelegate?,
    to object: ASAuthorizationController
  ) {
    object.delegate = delegate
  }
}

extension RxASAuthorizationControllerProxy: ASAuthorizationControllerDelegate { }
