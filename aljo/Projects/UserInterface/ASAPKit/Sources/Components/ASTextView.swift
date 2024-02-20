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

public class ASTextView: UIView {
  private var shouldShowTextCount: Bool = false
  
  private let textView: UITextView = UITextView()
  private let countLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.caption3)
    label.textAlignment = .right
    return label
  }()
  
  private var disposeBag = DisposeBag()
  
  public init(shouldShow: Bool) {
    self.shouldShowTextCount = shouldShow
    super.init(frame: .zero)
    
    textView.font = .pretendard(.body3)
    textView.contentInset = UIEdgeInsets(top: 13, left: 16, bottom: 13, right: 16)
    
    configureUI()
    
    layer.borderColor = UIColor.gray03.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 6
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func configureUI() {
    if shouldShowTextCount == false {
      addSubview(textView)
      
      textView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
      
      return
    }
    
    [textView, countLabel].forEach(addSubview)
    
    textView.snp.makeConstraints {
      $0.top.horizontalEdges.equalToSuperview()
    }
    
    countLabel.snp.makeConstraints {
      $0.top.equalTo(textView.snp.bottom).offset(15)
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-10)
    }
  }
}