//
//  AJValidGroupPasswordUseCase.swift
//  GroupDomainImplementation
//
//  Created by 이태영 on 5/4/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import GroupDomainInterface

final class AJValidGroupPasswordUseCase: ValidGroupPasswordUseCase {
  func excute(with password: String) -> Bool {
    let passwordRegex = "[0-9]{4}"
    let isValid = password.range(of: passwordRegex, options: .regularExpression) != nil
    return isValid
  }
  
  init() { }
}
