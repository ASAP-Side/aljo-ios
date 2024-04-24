//
//  DummyRouter.swift
//  AJNetworkTesting
//
//  Created by 이태영 on 2/1/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import AJNetworkInterface

import Alamofire

public enum DummyRouter: NetworkRouter {
  case dummyGet
  case dummyPost
  case dummy
  
  public var baseURL: String {
    return "www.base.com"
  }
  
  public var method: HTTPMethod {
    switch self {
    case .dummyGet:
      return .get
    case .dummyPost:
      return .post
    case .dummy:
      return .get
    }
  }
  
  public var path: String {
    switch self {
    case .dummyGet:
      return ""
    case .dummyPost:
      return ""
    case .dummy:
      return "/path"
    }
  }
  
  public var headers: HTTPHeaders {
    switch self {
    case .dummyGet:
      return []
    case .dummyPost:
      return []
    case .dummy:
      return [HTTPHeader.contentType("application/json")]
    }
  }
  
  public var behavior: RequestBehavior {
    switch self {
    case .dummyGet:
      return .plain
    case .dummyPost:
      return .uploadMultipartFormData(MultipartFormData(), parameters: [:])
    case .dummy:
      return .plain
    }
  }
}
