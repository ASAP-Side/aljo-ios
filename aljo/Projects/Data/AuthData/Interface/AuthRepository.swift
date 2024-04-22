//
//  AuthRepository.swift
//  AuthDataInterface
//
//  Created by 이태영 on 4/18/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AuthDomainInterface

import RxSwift

public protocol AuthRepository {
  func login(with service: AuthorizationService, token: String) -> Observable<Void>
}
