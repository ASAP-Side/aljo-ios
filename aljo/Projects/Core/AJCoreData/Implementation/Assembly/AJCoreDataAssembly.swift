//
//  AJCoreDataAssembly.swift
//  AJCoreDataInterface
//
//  Created by 이태영 on 4/23/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AJCoreDataInterface

import Swinject

public final class AJCoreDataAssembly: Assembly {
  public func assemble(container: Container) {
    container.register(CoreDataStorage.self) { _ in
      AJCoreDataStorage()
    }
  }
}
