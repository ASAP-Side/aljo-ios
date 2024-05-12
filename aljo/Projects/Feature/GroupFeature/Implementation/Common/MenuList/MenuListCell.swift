//
//  MenuListCell.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/12/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import SnapKit

final class MenuListCell: UITableViewCell {
  private let iconImageView = UIImageView()
  private let label: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.body2)
    label.textColor = .black02
    return label
  }()
  
  override init(
    style: UITableViewCell.CellStyle,
    reuseIdentifier: String?
  ) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configureUI()
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureCell(with contents: MenuListCellContent) {
    iconImageView.image = contents.image
    label.text = contents.text
  }
  
  private func configureUI() {
    [iconImageView, label].forEach {
      contentView.addSubview($0)
    }
    
    iconImageView.snp.makeConstraints {
      $0.leading.equalTo(contentView.snp.leading).offset(20)
      $0.width.equalTo(24)
      $0.height.equalTo(iconImageView.snp.width)
      $0.top.equalTo(contentView.snp.top).offset(14)
      $0.bottom.equalTo(contentView.snp.bottom).offset(-14)
    }
    
    label.snp.makeConstraints {
      $0.leading.equalTo(iconImageView.snp.trailing).offset(12)
      $0.centerY.equalTo(iconImageView.snp.centerY)
    }
  }
}
