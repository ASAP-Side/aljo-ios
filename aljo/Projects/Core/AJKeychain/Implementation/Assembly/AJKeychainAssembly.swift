//
//  AJKeychainAssembly.swift
//  AJKeychainImplementation
//
//  Created by 이태영 on 4/23/24.
//

import AJKeychainInterface

import Swinject

public final class AJKeychainAssembly: Assembly {
  public func assemble(container: Swinject.Container) {
    container.register(KeyChainStorage.self) { _, key, service in
      AJKeyChainStorage(key: key, service: service)
    }
  }
}
