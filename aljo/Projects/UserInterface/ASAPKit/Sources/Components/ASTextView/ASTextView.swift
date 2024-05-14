//
//  ASTextView.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import SnapKit
import RxSwift
import RxRelay
import RxCocoa

extension String {
  func toAttributedString(
    with style: UIFont.PretendardStyle,
    _ styleHandler: ((inout NSMutableParagraphStyle) -> Void)? = nil
  ) -> NSMutableAttributedString {
    let attributedString = NSMutableAttributedString(string: self)
    
    var paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.maximumLineHeight = style.lineHeight
    paragraphStyle.minimumLineHeight = style.lineHeight
    paragraphStyle.lineBreakMode = .byTruncatingTail
    styleHandler?(&paragraphStyle)
    
    let range = NSRange(location: .zero, length: attributedString.length)
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    return attributedString
  }
  
  var isConsonant: Bool {
    let consonantScalarRange: ClosedRange<UInt32> = 12593...12622
    guard let scalar = UnicodeScalar(self)?.value else {
      return false
    }
    
    return consonantScalarRange ~= scalar
  }
  
  var isVowel: Bool {
    let consonantScalarRange: ClosedRange<UInt32> = 12623...12643
    guard let scalar = UnicodeScalar(self)?.value else {
      return false
    }
    
    return consonantScalarRange ~= scalar
  }
}

extension NSMutableAttributedString {
  func color(_ color: UIColor, of searchTerm: String) -> NSMutableAttributedString {
    let length = self.string.count
    var range = NSRange(location: .zero, length: length)
    var rangeArray = [NSRange]()
    
    while range.location != NSNotFound {
      range = (self.string as NSString)
        .range(of: searchTerm, options: .caseInsensitive, range: range)
      rangeArray.append(range)
      
      if range.location != NSNotFound {
        range = NSRange(
          location: range.location + range.length,
          length: self.string.count - (range.location + range.length)
        )
      }
    }
    
    rangeArray.forEach {
      self.addAttribute(.foregroundColor, value: color, range: $0)
    }
    return self
  }
}

extension UIColor {
  convenience init?(coreColor: CGColor?) {
    if let coreColor = coreColor {
      self.init(cgColor: coreColor)
    }
    
    return nil
  }
}

public extension Reactive where Base: ASTextView {
  var text: ControlProperty<String?> {
    return base.textView.rx.text
  }
}

/// 여러줄의 글자를 입력할 수 있는 ASAP 팀만의 TextView입니다.
public class ASTextView: UIView {
  // MARK: VIEW PROPERTIES
  internal let textView: UITextView = {
    let textView = UITextView()
    textView.textColor = .black01
    textView.font = .pretendard(.body3)
    textView.autocorrectionType = .no
    textView.autocapitalizationType = .none
    return textView
  }()
  
  private let countLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.caption3)
    label.textAlignment = .right
    label.textColor = .black01
    return label
  }()
  
  private let placeholderLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.body3)
    label.textColor = .black04
    label.isHidden = true
    return label
  }()
  
  // MARK: PROPERTIES
  /// 뷰 백그라운드 색상을 변경합니다.
  public var layerColor: UIColor? {
    get { return UIColor(coreColor: layer.backgroundColor) }
    set {
      self.layer.backgroundColor = newValue?.cgColor
      self.textView.backgroundColor = newValue
    }
  }
  
  /// 본문의 폰트를 변경합니다.
  public var font: UIFont? {
    get { return textView.font }
    set { textView.font = newValue }
  }
  
  /// 본문에 작성된 글자의 세수를 세주는 뷰에 대해서 숨기는 여부를 결정합니다.
  public var isShowCount: Bool {
    get { return countLabel.isHidden }
    set { countLabel.isHidden = (newValue == false) }
  }
  
  public var placeholder: String? {
    get { placeholderLabel.text }
    set { 
      placeholderLabel.text = newValue
      placeholderLabel.isHidden = false
    }
  }
  
  private var maxLength: Int = 1
  
  // MARK: - INITIALIZER
  /// 생성자입니다. 다른 방법으로 타입을 생성하지 마십시오.
  /// - Parameters:
  ///   - placeholder: 본문이 비어있는 경우 표시될 글귀입니다. 기본값으로 제공되는 빈문자열을 통해서 생성하게 되면, 보여지지 않습니다.
  ///   - maxLength: 본문에 들어갈 수 있는 최대 글자수를 지정합니다. 0 이하의 수를 통해서 생성하게 되면, 최대 글자수가 1이 됩니다.
  public convenience init(maxLength: Int = .zero) {
    self.init(frame: .zero)
  
    self.maxLength = (maxLength == .zero) ? 1 : maxLength
    
    setUpSubViews()
    textView.delegate = self
  }
}

extension ASTextView: UITextViewDelegate {
  public func textViewDidChange(_ textView: UITextView) {
    placeholderLabel.isHidden = (textView.text.isEmpty == false)
    if textView.text.count > maxLength { textView.deleteBackward() }
    
    updateCountText(textView.text.count)
  }
  
  public func textViewDidBeginEditing(_ textView: UITextView) {
    layer.borderColor = UIColor.black01.cgColor
    layer.borderWidth = 1.5
  }
  
  public func textViewDidEndEditing(_ textView: UITextView) {
    layer.borderColor = UIColor.gray02.cgColor
    layer.borderWidth = 1
  }
  
  public func textView(
    _ textView: UITextView,
    shouldChangeTextIn range: NSRange,
    replacementText text: String
  ) -> Bool {
    let currentText = textView.text as NSString? ?? ""
    let changedText = currentText.replacingCharacters(in: range, with: text)
    
    if changedText.count <= maxLength { return true }
    
    let lastCharacter = (currentText as String).last ?? Character(".")
    let separatedCharacters = String(lastCharacter)
      .decomposedStringWithCanonicalMapping
      .unicodeScalars
      .map { String($0) }
    
    if text.isVowel { return separatedCharacters.count == 1 }
    if text.isConsonant { return (2...3) ~= separatedCharacters.count }
    return false
  }
}

// MARK: VIEW ACTION METHODS
private extension ASTextView {
  func updateCountText(_ currentLength: Int) {
    countLabel.attributedText = "\(currentLength) / \(maxLength)"
      .toAttributedString(with: .caption3) { $0.alignment = .right }
      .color(.black04, of: "/ \(maxLength)")
      .color(.black01, of: "\(currentLength) ")
  }
}

// MARK: CONFIGURE UI METHODS
private extension ASTextView {
  func setUpSubViews() {
    updateCountText(.zero)
    tintColor = .red01
    layer.borderColor = UIColor.gray02.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 6
    
    configureHierarchy()
    configureCostraints()
  }
  
  func configureHierarchy() {
    [textView, countLabel, placeholderLabel].forEach(addSubview)
  }
  
  func configureCostraints() {
    textView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(13)
      $0.horizontalEdges.equalToSuperview().inset(11)
      $0.bottom.equalToSuperview().offset(-43)
    }
    
    countLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-11)
    }
    
    placeholderLabel.snp.makeConstraints {
      $0.top.equalTo(textView.snp.top).inset(textView.textContainerInset.top)
      $0.horizontalEdges.equalTo(textView.snp.horizontalEdges).inset(5)
    }
  }
}
