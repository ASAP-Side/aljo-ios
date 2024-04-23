//
//  Router.swift
//  AJNetworkInterface
//
//  Created by 이태영 on 1/31/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//
import Foundation

import Alamofire

public protocol NetworkRouter: URLRequestConvertible {
  var baseURL: String { get }
  var method: HTTPMethod { get }
  var path: String { get }
  var headers: HTTPHeaders { get }
  var behavior: RequestBehavior { get }
}

public extension NetworkRouter {
  func asURLRequest() throws -> URLRequest {
    let urlString = baseURL + path
    var request = try URLRequest(url: urlString, method: method, headers: headers)
    
    switch behavior {
    case let .requestURLEncoded(parameters):
      request = try URLEncoding.httpBody.encode(request, with: parameters)
      
    case let .requestJsonEncodable(parameters):
      request = try JSONParameterEncoder.default.encode(parameters, into: request)
      
    case let .requestParameters(parameters, encoding):
      request = try encoding.encode(request, with: parameters)
      
    default:
      break
    }
    
    return request
  }
}
