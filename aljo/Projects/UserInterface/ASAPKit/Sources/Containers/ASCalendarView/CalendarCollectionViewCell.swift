//
//  CalendarCollectionViewCell.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {
  // TODO: - REUSABLE 프로토콜 만들어서 채택하기
  static let identifier: String = "CalendarCollectionViewCell"
  
  private let selectLayer: CAShapeLayer = {
    let layer = CAShapeLayer()
    layer.backgroundColor = UIColor.red01.cgColor
    layer.isHidden = true
    return layer
  }()
  
  private let dayLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.body3)
    label.textColor = .label
    label.textAlignment = .center
    return label
  }()
  
  private var isSelectable: Bool = false
  private var isSunday: Bool = false
  
  private var selectableColor: UIColor {
    return self.isSunday ? .red500 : .black01
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configure()
  }
  
  @available(*, unavailable, message: "스토리보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    selectLayer.isHidden = true
    dayLabel.font = .pretendard(.body3)
    dayLabel.textColor = .black01
    dayLabel.text = nil
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    selectLayer.frame = bounds.insetBy(dx: 10, dy: 10)
    let minLength = min(selectLayer.frame.width, selectLayer.frame.height)
    selectLayer.cornerRadius = minLength / 2
    
    layer.insertSublayer(selectLayer, at: 0)
  }
  
  private func configure() {
    contentView.addSubview(dayLabel)
    
    dayLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func configureDay(to date: CalendarDate) {
    if date.isEmpty { return }
    isSunday = date.isSunday
    
    dayLabel.text = "\(date.day)"
    dayLabel.textColor = (date.isSelectable == false) ? .black04 : selectableColor
    isSelectable = date.isSelectable
  }
  
  func updateSelect(to isSelected: Bool) {
    if isSelectable == false { return }
    
    selectLayer.isHidden = (isSelected == false)
    
    if isSelected == true {
      dayLabel.font = .pretendard(.headLine6)
      dayLabel.textColor = .white
      return
    }
    
    if isSelected == false {
      dayLabel.font = .pretendard(.body3)
      dayLabel.textColor = selectableColor
      return
    }
  }
}
