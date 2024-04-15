//
//  AuthController.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthenticationServices
import UIKit

import RxSwift

public final class AuthController: NSObject {
  private let window: UIWindow?
  
  public init(window: UIWindow?) {
    self.window = window
  }
  
  func signInWithApple() -> Observable<String> {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    
    return authorizationController.rx.didCompleteAuthorization
  }
}

extension AuthController: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    guard let window = window else {
      assert(false, "window miss")
      return .init()
    }
    return window
  }
}
