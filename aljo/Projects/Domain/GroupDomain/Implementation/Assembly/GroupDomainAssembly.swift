//
//  GroupDomainAssembly.swift
//  GroupDomainImplementation
//
//  Created by 이태영 on 5/7/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import GroupDomainInterface

import Swinject

public final class GroupDomainAssembly: Assembly {
  public init() { }
  
  public func assemble(container: Container) {
    container.register(ValidGroupPasswordUseCase.self) { _ in
      AJValidGroupPasswordUseCase()
    }
  }
}
