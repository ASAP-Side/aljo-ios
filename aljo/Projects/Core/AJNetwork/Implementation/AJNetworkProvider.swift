//
//  AJNetworkProvider.swift
//  AJNetworkImplemenetation
//
//  Created by 이태영 on 2/1/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import AJNetworkInterface
import Foundation

import RxSwift
import Alamofire

struct AJNetworkProvider: NetworkProvider {
  private let session: Session
  
  init(session: Session = .default) {
    self.session = session
  }
  
  public func string(_ router: NetworkRouter) -> Observable<String> {
    return request(to: router).compactMap { String(data: $0, encoding: .utf8) }
  }
  
  public func decodable<T: Decodable>(_ router: NetworkRouter) -> Observable<T> {
    return request(to: router).decode(type: T.self, decoder: JSONDecoder())
  }
  
  public func data(_ router: NetworkRouter) -> Observable<Data> {
    return request(to: router)
  }
}

// MARK: - Private Method
extension AJNetworkProvider {
  private func request(to router: NetworkRouter) -> Observable<Data> {
    if case let .uploadMultipartFormData(multipartFormData, _) = router.behavior {
      return upload(to: router, with: multipartFormData)
    }
    
    return Observable.create { emitter in
      let request = session.request(router)
        .validate()
        .responseData { response in
          switch response.result {
          case .success(let data):
            emitter.onNext(data)
          case .failure(let error):
            emitter.onError(error)
          }
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
  
  private func upload(to router: NetworkRouter, with multipartFormData: MultipartFormData) -> Observable<Data> {
    return Observable.create { emitter in
      let request = session.upload(multipartFormData: multipartFormData, with: router)
        .validate()
        .responseData { response in
          switch response.result {
          case .success(let data):
            emitter.onNext(data)
          case .failure(let error):
            emitter.onError(error)
          }
        }
      
      return Disposables.create {
        request.cancel()
      }
    }
  }
}
