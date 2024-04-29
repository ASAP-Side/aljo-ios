//
//  KeyChain.swift
//  AJKeychainInterface
//
//  Copyright (c) 2024 Minii All rights reserved.

import Foundation

import RxSwift

public protocol KeyChainStorage {
  func upsert(item: Data) -> Observable<Void>
  func fetch() -> Observable<Data>
  func delete() -> Observable<Void>
}
