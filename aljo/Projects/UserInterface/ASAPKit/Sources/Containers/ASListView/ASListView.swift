//
//  ASListView.swift
//  ASAPKit
//
//  Created by 이태영 on 3/6/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import UIKit

import SnapKit

public final class ASListView: UIView {
  // MARK: - Components
  private let scrollView = UIScrollView()
  private let itemStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.alignment = .fill
    stackView.distribution = .fill
    return stackView
  }()
  
  // MARK: - Public
  public var spacing: CGFloat {
    get { itemStackView.spacing }
    set { itemStackView.spacing = newValue }
  }
  
  public var contentInset: UIEdgeInsets {
    get { scrollView.contentInset }
    set { scrollView.contentInset = newValue }
  }
  
  public var contentOffset: CGPoint {
    get { scrollView.contentOffset }
    set { scrollView.contentOffset = newValue }
  }
  
  public var contentOrigin: CGPoint {
    itemStackView.frame.origin
  }
  
  public func addItem(_ item: UIView, title: String? = nil) {
    let headerBox = HeaderBox(contentView: item, title: title)
    itemStackView.addArrangedSubview(headerBox)
  }
  
  public func addSeperator() {
    let view = UIView()
    view.backgroundColor = .gray01
    view.snp.makeConstraints {
      $0.height.equalTo(10)
    }
    itemStackView.addArrangedSubview(view)
  }
  
  // MARK: - init
  public init() {
    super.init(frame: .zero)
    configureUI()
    configureAction()
    scrollView.delegate = self
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - UIScrollViewDelegate
extension ASListView: UIScrollViewDelegate {
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    endEditing(true)
  }
}

// MARK: - Action Configuration
extension ASListView {
  private func configureAction() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapScrollView))
    tapGesture.cancelsTouchesInView = false
    scrollView.addGestureRecognizer(tapGesture)
  }
  
  @objc
  private func tapScrollView() {
    endEditing(true)
  }
}

// MARK: - UI Configuration
extension ASListView {
  private func configureUI() {
    configureHirearchy()
    configureConstraints()

  }
  
  private func configureHirearchy() {
    addSubview(scrollView)
    scrollView.addSubview(itemStackView)
  }
  
  private func configureConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    itemStackView.snp.makeConstraints {
      $0.edges.equalTo(scrollView.contentLayoutGuide.snp.edges)
      $0.width.equalTo(scrollView.frameLayoutGuide.snp.width)
    }
  }
}
