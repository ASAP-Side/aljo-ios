//
//  ASRoundButton.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import RxSwift

public class RoundButton: UIButton {
  public var baseBackgroundColor: UIColor?
  public var selectedBackgroundColor: UIColor?
  
  public var baseBorderColor: UIColor?
  public var selectedBorderColor: UIColor?
  
  public init() {
    super.init(frame: .zero)
    
    generateInitConfiguration()
  }
  
  public func generateInitConfiguration() {
    var configuration = UIButton.Configuration.plain()
    configuration.titleAlignment = .center
    configuration.background.strokeWidth = 1
    configuration.cornerStyle = .capsule
    configuration.baseForegroundColor = .black
    
    self.configuration = configuration
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  @available(*, unavailable, message: "사용할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}