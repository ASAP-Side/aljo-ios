//
//  AuthRepository.swift
//  AuthDataInterface
//
//  Created by 이태영 on 4/18/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import RxSwift
import AuthDomainInterface

protocol AuthRepository {
  func login(with service: AuthorizationService) -> Observable<Void>
}
