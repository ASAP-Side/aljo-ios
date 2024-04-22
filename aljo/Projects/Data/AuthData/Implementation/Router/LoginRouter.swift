//
//  LoginRouter.swift
//  AuthDataInterface
//
//  Created by 이태영 on 4/18/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AJNetworkInterface

import Alamofire

enum LoginRouter: Router {
  case loginWithApple(user: AppleUser)
  case loginWithKakao(token: KakaoAccessToken)
  
  var baseURL: String {
    return "https://asap-api.click"
  }
  
  var method: HTTPMethod {
    switch self {
    case .loginWithApple:
      return .post
    case .loginWithKakao:
      return .post
    }
  }
  
  var path: String {
    switch self {
    case .loginWithApple:
      return "/oauth/apple"
    case .loginWithKakao:
      return "/oauth/kakao"
    }
  }
  
  var headers: HTTPHeaders {
    return []
  }
  
  var behavior: RequestBehavior {
    switch self {
    case .loginWithApple(let user):
      return .requestJsonEncodable(user)
    case .loginWithKakao(let token):
      return .requestJsonEncodable(token)
    }
  }
}
