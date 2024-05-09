//
//  CalendarCollectionViewCell.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

final class CalendarCollectionViewCell: UICollectionViewCell {
  // TODO: - REUSABLE 프로토콜 만들어서 채택하기
  static let identifier: String = "CalendarCollectionViewCell"
  
  private let selectBackgrounView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.clear
    return view
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
    selectBackgrounView.backgroundColor = UIColor.clear
    dayLabel.font = .pretendard(.body3)
    dayLabel.textColor = .black01
    dayLabel.text = nil
    super.prepareForReuse()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    selectBackgrounView.layer.cornerRadius = selectBackgrounView.frame.width / 2
  }
  
  private func configure() {
    contentView.addSubview(selectBackgrounView)
    contentView.addSubview(dayLabel)
    
    dayLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    selectBackgrounView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(8)
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
    
    if isSelected == true {
      dayLabel.font = .pretendard(.headLine6)
      dayLabel.textColor = .white
      selectBackgrounView.backgroundColor = UIColor.red01
      return
    }
    
    if isSelected == false {
      dayLabel.font = .pretendard(.body3)
      dayLabel.textColor = selectableColor
      selectBackgrounView.backgroundColor = UIColor.clear
      return
    }
  }
}
