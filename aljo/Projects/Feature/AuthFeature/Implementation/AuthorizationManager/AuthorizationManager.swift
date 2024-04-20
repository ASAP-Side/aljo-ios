//
//  AuthorizationManager.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthenticationServices
import UIKit

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import RxKakaoSDKCommon
import RxKakaoSDKAuth
import RxKakaoSDKUser

public final class AuthorizationManager: NSObject { }

// MARK: - Sign In With Apple
extension AuthorizationManager: ASAuthorizationControllerPresentationContextProviding {
  public func signInWithApple() -> Observable<String> {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
    
    return authorizationController.rx.didCompleteAuthorization
  }
  
  public func presentationAnchor(
    for controller: ASAuthorizationController
  ) -> ASPresentationAnchor {
    guard let appDelegate = UIApplication.shared.delegate,
          let window = appDelegate.window,
          let window = window
    else {
      return .init()
    }
    
    return window
  }
}

// MARK: - Sign In With Kakao
extension AuthorizationManager {
  public func initKakaoSDK(with appKey: String) {
    RxKakaoSDK.initSDK(appKey: appKey)
  }
  
  public func signInWithKakao() -> Observable<String> {
    if UserApi.isKakaoTalkLoginAvailable() {
      return UserApi.shared.rx.loginWithKakaoTalk()
        .map { $0.accessToken }
    } else {
      return UserApi.shared.rx.loginWithKakaoAccount()
        .map { $0.accessToken }
    }
  }
  
  public func handleKakaoTalkURL(with url: URL) -> Bool {
    if AuthApi.isKakaoTalkLoginUrl(url) {
      return AuthController.rx.handleOpenUrl(url: url)
    }
    
    return false
  }
}
