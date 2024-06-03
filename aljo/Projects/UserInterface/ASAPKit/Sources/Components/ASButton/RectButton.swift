//
//  ASRectButton.swift
//  ASAPKit
//
//  Created by 이태영 on 2/28/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import UIKit

typealias ForegroundColorAttribute = AttributeScopes.UIKitAttributes.ForegroundColorAttribute
typealias FontAttribute = AttributeScopes.UIKitAttributes.FontAttribute

public final class ASRectButton: UIButton {
  private let style: Configuration.ASRectStyle
  
  public var title: String? {
    didSet {
      configureTitleConfiguration(with: style)
    }
  }
  
  public var image: UIImage? {
    didSet {
      configureImageConfiguration(with: style)
    }
  }
  
  public var selectedImage: UIImage?
  
  public init(style: Configuration.ASRectStyle) {
    self.style = style
    super.init(frame: .zero)
    
    configuration = Configuration.rect(style: style)
    
    switch style {
    case .fill:
      configurationUpdateHandler = makeFillStyleUpdatehandler()
    case .stroke:
      configurationUpdateHandler = makeStrokeStyleUpdatehandler()
    case .strokeImage:
      configurationUpdateHandler = makeStrokeImageStyleUpdateHandler()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func draw(_ rect: CGRect) {
    super.draw(rect)
    
    if case .dynamic = style.imagePadding {
      let titleWidth = titleLabel?.frame.width ?? 0
      let imageWidth = imageView?.frame.width ?? 0
      let leadingPadding = style.contentInsets.leading
      let trailingPadding = style.contentInsets.trailing
      let contentWidth = titleWidth + imageWidth + leadingPadding + trailingPadding
      configuration?.imagePadding = frame.width - contentWidth - 10
    }
  }
  
  private func configureTitleConfiguration(with style: Configuration.ASRectStyle) {
    var titleContainer = AttributeContainer()
    titleContainer.font = style.font
    titleContainer.foregroundColor = style.titleColor
    configuration?.attributedTitle = AttributedString(title ?? "", attributes: titleContainer)
  }
  
  private func configureImageConfiguration(with style: Configuration.ASRectStyle) {
    configuration?.image = image
    
    if case let .fixed(padding) = style.imagePadding {
      configuration?.imagePadding = padding
    }
    
    if let imagePlacement = style.imagePlacement {
      configuration?.imagePlacement = imagePlacement
    }
  }
  
  private func makeFillStyleUpdatehandler() -> ((UIButton) -> Void) {
    return { [weak self] button in
      var configuration = self?.configuration
      
      switch button.state {
      case .normal:
        configuration?.background.backgroundColor = .red01
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .white
      case .disabled:
        configuration?.background.backgroundColor = .gray02
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .black04
      default:
        break
      }
      
      self?.configuration = configuration
    }
  }
  
  private func makeStrokeStyleUpdatehandler() -> ((UIButton) -> Void) {
    return { [weak self] button in
      var configuration = self?.configuration
      
      switch button.state {
      case .normal:
        configuration?.background.strokeWidth = 1
        configuration?.background.strokeColor = .gray02
        configuration?.background.backgroundColor = .white
        configuration?.attributedTitle?[FontAttribute.self] = .pretendard(.body5)
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .black01
      case .selected:
        configuration?.background.strokeWidth = 1.5
        configuration?.background.strokeColor = .red01
        configuration?.background.backgroundColor = .red02
        configuration?.attributedTitle?[FontAttribute.self] = .pretendard(.headLine6)
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .red01
      default:
        break
      }
      
      self?.configuration = configuration
    }
  }
  
  private func makeStrokeImageStyleUpdateHandler() -> ((UIButton) -> Void) {
    return { [weak self] button in
      var configuration = self?.configuration
      
      switch button.state {
      case .normal:
        configuration?.background.strokeColor = .gray02
        configuration?.background.backgroundColor = .white
        configuration?.attributedTitle?[FontAttribute.self] = .pretendard(.body3)
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .black01
        configuration?.image = self?.image
      case .selected:
        configuration?.background.strokeColor = .red01
        configuration?.background.backgroundColor = .red02
        configuration?.attributedTitle?[FontAttribute.self] = .pretendard(.headLine6)
        configuration?.attributedTitle?[ForegroundColorAttribute.self] = .red01
        configuration?.image = self?.selectedImage
      default:
        break
      }
      
      self?.configuration = configuration
    }
  }
}
