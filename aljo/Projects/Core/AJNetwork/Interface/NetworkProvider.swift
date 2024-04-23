//
//  Provider.swift
//  AJNetworkInterface
//
//  Created by 이태영 on 1/31/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import Foundation

import RxSwift

public protocol NetworkProvider {
  func string(_ router: NetworkRouter) -> Observable<String>
  func decodable<T: Decodable>(_ router: NetworkRouter) -> Observable<T>
  func data(_ router: NetworkRouter) -> Observable<Data>
}
