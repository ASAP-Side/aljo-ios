//
//  ASBorderHighlightTextField.swift
//  ASAPKit
//
//  Created by 이태영 on 2/19/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import UIKit

public final class ASBorderHighlightTextField: UITextField {
  private let inset = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
  
  // MARK: - public
  public override var placeholder: String? {
    get { super.placeholder }
    set {
      attributedPlaceholder = NSAttributedString(
        string: newValue ?? "",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black04]
      )
    }
  }
  
  public var maxTextCount: UInt = 0
  
  // MARK: - init
  public init() {
    super.init(frame: .zero)
    delegate = self
    configureUI()
    configureAction()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - override
  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: inset)
  }
  
  public override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return bounds.inset(by: inset)
  }
}

// MARK: UITextField Delegate
extension ASBorderHighlightTextField: UITextFieldDelegate {
  public func textFieldDidBeginEditing(_ textField: UITextField) {
    layer.borderColor = UIColor.black01.cgColor
    layer.borderWidth = 1.5
  }
  
  public func textFieldDidEndEditing(_ textField: UITextField) {
    layer.borderColor = UIColor.gray02.cgColor
    layer.borderWidth = 1
  }
  
  public func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let currentText = textField.text as NSString? ?? ""
    let changedText = currentText.replacingCharacters(in: range, with: string)
    
    if changedText.count <= maxTextCount || maxTextCount == 0 {
      return true
    }
    
    let lastCharacter = (currentText as String).last ?? Character(".")
    let separatedCharacters = String(lastCharacter)
      .decomposedStringWithCanonicalMapping
      .unicodeScalars
      .map { String($0) }
    
    if string.isVowel { return separatedCharacters.count == 1 }
    if string.isConsonant { return (2...3) ~= separatedCharacters.count }
    return false
  }
}

// MARK: Configure Action
extension ASBorderHighlightTextField {
  private var editingTextFieldAction: UIAction {
    UIAction { [weak self] _ in
      guard let self = self else {
        return
      }
      
      let text = self.text ?? ""
      
      if text.count > maxTextCount && maxTextCount != 0 {
        self.text = String(text.dropLast())
      }
    }
  }
  
  private func configureAction() {
    addAction(editingTextFieldAction, for: .editingChanged)
  }
}
// MARK: UI Configuration
extension ASBorderHighlightTextField {
  private func configureUI() {
    font = .pretendard(.body3)
    textColor = .black01
    tintColor = .red01
    layer.borderWidth = 1
    layer.borderColor = UIColor.gray02.cgColor
    layer.cornerRadius = 6
  }
}
