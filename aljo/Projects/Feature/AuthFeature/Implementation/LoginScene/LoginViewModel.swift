//
//  LoginViewModel.swift
//  AuthFeatureImplementation
//
//  Created by 이태영 on 4/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface

import RxSwift
import RxCocoa

public final class LoginViewModel: ViewModelable {
  public struct Input {

  }
  
  public struct Output {
    
  }
  
  private let authorizationManager: AuthorizationManager
  
  public func transform(to input: Input) -> Output {
    return Output()
  }
  
  public init(authorizationManager: AuthorizationManager) {
    self.authorizationManager = authorizationManager
  }
}
