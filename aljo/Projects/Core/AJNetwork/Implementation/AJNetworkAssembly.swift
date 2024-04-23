//
//  AJNetworkAssembly.swift
//  AJNetworkImplementation
//
//  Created by 이태영 on 4/23/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import AJNetworkInterface

import Swinject

final class AJNetworkAssembly: Assembly {
  func assemble(container: Container) {
    container.register(Provider.self) { _ in
      NetworkProvider()
    }
  }
}
