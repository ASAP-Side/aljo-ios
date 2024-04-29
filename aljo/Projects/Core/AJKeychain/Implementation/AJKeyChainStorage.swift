//
//  AJKeyChainStorage.swift
//  AJKeychainInterface
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

import AJKeychainInterface

import RxSwift

final class AJKeyChainStorage: KeyChainStorage {
  private let attributes: [String: Any]
  private let scheduler = ConcurrentDispatchQueueScheduler(qos: .background)
  
  init(key: String, service: String) {
    self.attributes = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecAttrService as String: service
    ]
  }
  
  func upsert(item: Data) -> Observable<Void> {
    return Observable.create { [weak self] observer in
      var result: OSStatus = errSecSuccess
      
      self?.add(item: item, result: &result)
      
      if result == errSecDuplicateItem {
        self?.update(item: item, result: &result)
      }
      
      if result == errSecSuccess {
        observer.onNext(())
      } else {
        observer.onError(KeyChainError.unknown(result))
      }
      
      return Disposables.create()
    }
    .subscribe(on: scheduler)
  }
  
  func fetch() -> Observable<Data> {
    var query = attributes
    query.updateValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)
    query.updateValue(true, forKey: kSecReturnData as String)
    
    return Observable.create { [weak self] observer in
      var value: CFTypeRef?
      
      let result = SecItemCopyMatching(query as CFDictionary, &value)
      
      do {
        if result != errSecSuccess { observer.onError(KeyChainError.unknown(result))}
        
        if let decodeValue = try self?.decodeResults(to: value) {
          observer.onNext(decodeValue)
        } else {
          observer.onError(KeyChainError.invalidDecode)
        }
      } catch let error {
        observer.onError(error)
      }
      
      return Disposables.create()
    }
    .subscribe(on: scheduler)
  }
  
  func delete() -> Observable<Void> {
    var query = attributes

    return Observable.create { observer in
      let result = SecItemDelete(query as CFDictionary)
      
      if result == errSecSuccess {
        observer.onNext(())
      } else {
        observer.onError(KeyChainError.unknown(result))
      }
      
      return Disposables.create()
    }
    .subscribe(on: scheduler)
  }
  
  private func decodeResults(to result: CFTypeRef?) throws -> Data {
    guard let itemDictionary = result as? [String: Any],
          let data = itemDictionary[kSecAttrGeneric as String] as? Data else {
      throw KeyChainError.invalidDecode
    }

    return data
  }
  
  private func add(item: Data, result: inout OSStatus) {
    var attributes = attributes
    attributes.updateValue(item, forKey: kSecValueData as String)
    result = SecItemAdd(attributes as CFDictionary, nil)
  }
  
  private func update(item: Data, result: inout OSStatus) {
    let itemQuery = [kSecValueData as String: item] as CFDictionary
    result = SecItemUpdate(attributes as CFDictionary, itemQuery)
  }
}
