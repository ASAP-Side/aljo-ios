//
//  Configuration + Style.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii, 이태영 All rights reserved.

import UIKit

// MARK: - Button Style Static Method
public extension UIButton.Configuration {
  enum RoundStyle {
    case text
    case image
    case imageBorder
    
    var titleColor: UIColor? {
      switch self {
        case .text:   return .black01
        default:      return nil
      }
    }
    
    var selectedTitleColor: UIColor? {
      switch self {
        case .text:   return .red01
        default:      return nil
      }
    }
    
    var backgroundColor: UIColor? {
      return .white
    }
    
    var selectedBackgroundColor: UIColor? {
      switch self {
        case .text:         return .red02
        case .imageBorder:  return .red01
        default:            return nil
      }
    }
    
    var borderColor: UIColor? {
      switch self {
        case .text:           return .gray02
        case .imageBorder:    return .gray03
        default:              return nil
      }
    }
    
    var selectedBorderColor: UIColor? {
      switch self {
        case .text:      return .red01
        default:         return nil
      }
    }
    
    var font: UIFont? {
      switch self {
        case .text:     return .pretendard(.body3)
        default:        return nil
      }
    }
    
    var selectedFont: UIFont? {
      switch self {
        case .text:     return .pretendard(.headLine6)
        default:        return nil
      }
    }
    
    var selectedStrokeWidth: CGFloat {
      switch self {
        case .text:         return 1.5
        case .imageBorder:  return 1
        case .image:        return .zero
      }
    }
  }
  
  enum PaddingStyle {
    case fixed(padding: CGFloat)
    case dynamic
  }
  
  enum ASRectStyle {
    case fill
    case stroke
    case strokeImage(
      padding: PaddingStyle,
      placement: NSDirectionalRectEdge,
      contentInsets: NSDirectionalEdgeInsets
    )

    var contentInsets: NSDirectionalEdgeInsets {
      switch self {
      case .fill:
        return .init(top: 14, leading: 0, bottom: 14, trailing: 0)
      case .stroke:
        return .init(top: 12, leading: 0, bottom: 12, trailing: 0)
      case .strokeImage(_, _, let contentInsets):
        return contentInsets
      }
    }
    
    var titleColor: UIColor {
      switch self {
      case .fill:
        return .white
      case .stroke:
        return .black01
      case .strokeImage:
        return .black01
      }
    }
  
    var font: UIFont? {
      switch self {
      case .fill:
        return .pretendard(.headLine5)
      case .stroke:
        return .pretendard(.body5)
      case .strokeImage:
        return .pretendard(.body3)
      }
    }
    
    var cornerRadius: CGFloat {
      switch self {
      case .fill:
        return 10
      case .stroke:
        return 6
      case .strokeImage:
        return 10
      }
    }
    
    var strokeColor: UIColor? {
      switch self {
      case .fill:
        return nil
      case .stroke:
        return .red02
      case .strokeImage:
        return .red02
      }
    }
    
    var imagePlacement: NSDirectionalRectEdge? {
      switch self {
      case .fill:
        return nil
      case .stroke:
        return nil
      case .strokeImage(_, let placement, _):
        return placement
      }
    }
    
    var imagePadding: PaddingStyle? {
      switch self {
      case .fill:
        return nil
      case .stroke:
        return nil
      case .strokeImage(let padding, _, _):
        return padding
      }
    }
  }
  static func round(with style: RoundStyle) -> Self {
    var configuration = Self.plain()
    configuration.titleAlignment = .center
    configuration.background.strokeWidth = 1
    configuration.cornerStyle = .capsule
    return configuration
  }
  
  static func rect(style: ASRectStyle) -> Self {
    var configuration = plain()
    configuration.contentInsets = style.contentInsets
    
    var backgroundConfiguration = UIBackgroundConfiguration.clear()
    backgroundConfiguration.strokeColor = style.strokeColor
    backgroundConfiguration.cornerRadius = style.cornerRadius
    configuration.background = backgroundConfiguration
    
    return configuration
  }
}
