//
//  ViewModelable.swift
//  BaseFeatureImplementation
//
//  Copyright (c) 2024 Minii All rights reserved.

public protocol ViewModelable: AnyObject {
  associatedtype Input
  associatedtype Output
  
  func transform(to input: Input) -> Output
}
