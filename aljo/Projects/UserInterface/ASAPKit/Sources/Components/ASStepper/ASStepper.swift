//
//  ASStepper.swift
//  ASAPKit
//
//  Created by 이태영 on 2/29/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import UIKit

import SnapKit

public final class ASStepper: UIControl {
  private static func generateStepButton(
    to image: UIImage,
    normalColor: UIColor = .label,
    disableColor: UIColor = .gray02
  ) -> UIButton {
    var configuration = UIButton.Configuration.plain()
    configuration.image = image.withTintColor(normalColor, renderingMode: .alwaysOriginal)
    configuration.imageColorTransformer = .preferredTint
    
    let button = UIButton(configuration: configuration)
    
    button.configurationUpdateHandler = { button in
      var configuration = button.configuration
      let isDisable = button.state == .disabled
      
      if isDisable {
        configuration?.image = image.withTintColor(disableColor, renderingMode: .alwaysOriginal)
      } else {
        configuration?.image = image.withTintColor(normalColor, renderingMode: .alwaysOriginal)
      }
      button.configuration = configuration
    }
    
    return button
  }
  
  // MARK: - Components
  private let upButton: UIButton = generateStepButton(to: .Icon.plus)
  private let downButton: UIButton = generateStepButton(to: .Icon.minus)
  
  private let currentValueLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black01
    label.font = .pretendard(.body4)
    label.textAlignment = .center
    return label
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fill
    return stackView
  }()
  
  // MARK: - Public
  public var currentValue: Int {
    didSet {
      updateUI()
      sendActions(for: .valueChanged)
    }
  }
  var maximumValue: Int
  var minimumValue: Int
  
  public var stepValue: Int = 1
  
  // MARK: - init
  public init(current: Int = 0, min: Int = 0, max: Int = 100) {
    let isContainRangeCurrentValue = (min...max) ~= current
    assert(isContainRangeCurrentValue, "초기 설정 값은 최소, 최대 값을 벗어날 수 없습니다.")
    
    self.currentValue = current
    self.maximumValue = max
    self.minimumValue = min
    super.init(frame: .zero)
    
    configureUI()
    attachStepAction()
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Configure Action Methods
private extension ASStepper {
  func attachStepAction() {
    let upAction = UIAction { [weak self] _ in
      guard let self = self, currentValue < maximumValue else { return }
      
      currentValue += stepValue
    }
    
    let downAction = UIAction { [weak self] _ in
      guard let self = self, currentValue > minimumValue else { return }
      
      currentValue -= stepValue
    }
    
    upButton.addAction(upAction, for: .touchUpInside)
    downButton.addAction(downAction, for: .touchUpInside)
  }
}

// MARK: - Configure UI
extension ASStepper {
  private func configureUI() {
    configureHirachy()
    makeConstraints()
    updateUI()
  }
  
  private func configureHirachy() {
    addSubview(totalStackView)
    
    [downButton, currentValueLabel, upButton].forEach {
      totalStackView.addArrangedSubview($0)
      $0.setContentHuggingPriority(.required, for: .horizontal)
    }
  }
  
  private func makeConstraints() {
    totalStackView.snp.makeConstraints {
      $0.top.leading.trailing.bottom.equalToSuperview()
    }
    
    currentValueLabel.snp.makeConstraints {
      $0.width.greaterThanOrEqualTo(50)
    }
  }
  
  func updateUI() {
    currentValueLabel.text = "\(currentValue)"
    
    let isLessMaximum = (currentValue < maximumValue)
    let isMoreMinimum = (currentValue > minimumValue)
    
    upButton.isEnabled = isLessMaximum
    downButton.isEnabled = isMoreMinimum
  }
}
