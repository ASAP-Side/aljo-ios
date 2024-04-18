//
//  LoginUseCase.swift
//  AuthDomainInterface
//
//  Created by 이태영 on 4/18/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import RxSwift

public protocol LoginUseCase {
  func excute(with service: AuthorizationService, token: String) -> Observable<Void>
}
