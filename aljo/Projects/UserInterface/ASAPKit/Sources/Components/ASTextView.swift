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
    textView.textColor = .black04
    return textView
  }()
  
  private let countLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.caption3)
    label.textAlignment = .right
    label.textColor = .black01
    return label
  }()
  
  // MARK: PROPERTIES
  /// 태두리 색상을 변경합니다.
  public var borderColor: UIColor? {
    get { return UIColor(coreColor: layer.borderColor) }
    set { self.layer.borderColor = newValue?.cgColor }
  }
  
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
  
  private var placeholder: String = ""
  private var maxLength: Int = 1
  private var disposeBag = DisposeBag()
  
  // MARK: - INITIALIZER
  /// 생성자입니다. 다른 방법으로 타입을 생성하지 마십시오.
  /// - Parameters:
  ///   - placeholder: 본문이 비어있는 경우 표시될 글귀입니다. 기본값으로 제공되는 빈문자열을 통해서 생성하게 되면, 보여지지 않습니다.
  ///   - maxLength: 본문에 들어갈 수 있는 최대 글자수를 지정합니다. 0 이하의 수를 통해서 생성하게 되면, 최대 글자수가 1이 됩니다.
  public convenience init(placeholder: String = "", maxLength: Int = .zero) {
    self.init(frame: .zero)
    
    self.placeholder = placeholder
    self.maxLength = (maxLength == .zero) ? 1 : maxLength
    
    setUpSubViews()
    binding()
  }
  
  deinit {
    print("내려감")
  }
}

// MARK: BINDING METHODS
private extension ASTextView {
  func binding() {
    countLabel.rx.observe(\.isHidden, options: [.initial, .new])
      .bind(onNext: configureUI)
      .disposed(by: disposeBag)
    
    let textChangedEvent = textView.rx.text.orEmpty.changed.filter { $0 != self.placeholder }
    
    textChangedEvent.map(\.count)
      .bind(onNext: updateCountText)
      .disposed(by: disposeBag)
    
    textChangedEvent.scan("") { ($1.count > self.maxLength) ? $0 : $1 }
      .bind(to: textView.rx.text)
      .disposed(by: disposeBag)
    
    textView.rx.didEndEditing
      .map { _ in self.textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
      .filter { $0 }
      .bind(onNext: updateTextWhenEditingEnd)
      .disposed(by: disposeBag)
    
    textView.rx.didBeginEditing
      .map { self.textView.text == self.placeholder }
      .bind(onNext: updateTextWhenEditingStart)
      .disposed(by: disposeBag)
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
  
  func updateTextWhenEditingEnd(_ isEmpty: Bool) {
    if isEmpty == false { return }
    
    updateCountText(.zero)
    self.textView.text = self.placeholder
    self.textView.textColor = .black04
  }
  
  func updateTextWhenEditingStart(_ isEqual: Bool) {
    if isEqual == false { return }
    
    self.textView.text = nil
    self.textView.textColor = .black01
  }
}

// MARK: CONFIGURE UI METHODS
private extension ASTextView {
  func configureUI(isShowCount: Bool) {
    subviews.forEach { $0.removeFromSuperview() }
    
    if isShowCount {
      showCountLabelConstraints()
      return
    }
    
    hideCountLabelCostraints()
  }
  
  func showCountLabelConstraints() {
    addSubview(textView)
    
    textView.snp.makeConstraints {
      $0.verticalEdges.equalToSuperview().inset(13)
      $0.horizontalEdges.equalToSuperview().inset(16)
    }
  }
  
  func hideCountLabelCostraints() {
    [textView, countLabel].forEach(addSubview)
    
    textView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(13)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-40)
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalTo(textView.snp.bottom).offset(15)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
  
  func setUpSubViews() {
    textView.text = placeholder
    textView.font = .pretendard(.body3)
    updateCountText(.zero)
    
    layer.borderWidth = 1
    layer.cornerRadius = 6
  }
}
