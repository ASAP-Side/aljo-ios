//
//  AssetImageGridCell.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import SnapKit

protocol AssetImageGridCellDelegate: AnyObject {
  func assetImageGridCell(_ cell: AssetImageGridCell)
}

final class AssetImageGridCell: UICollectionViewCell {
  static let identifier = "AssetImageGridCell"
  // View Properties
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let selectedBlurView: UIView = {
    let view = UIView()
    view.backgroundColor = .clear
    view.alpha = 1
    return view
  }()
  
  private let checkButton: UIButton = {
    var configuration = UIButton.Configuration.filled()
    configuration.baseBackgroundColor = .white
    configuration.image = .Icon.check_small.withTintColor(.white)
    configuration.cornerStyle = .capsule
    configuration.background.strokeColor = .gray03
    configuration.background.strokeWidth = 1
    
    let button = UIButton(configuration: configuration)
    return button
  }()
  
  private let actionIdentifier = UIAction.Identifier(Constants.actionIdentifier)
  
  weak var delegate: AssetImageGridCellDelegate?
  
  // Life Cycle
  override func layoutSubviews() {
    super.layoutSubviews()
    
    configureUI()
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    self.imageView.image = nil
    self.checkButton.removeAction(identifiedBy: actionIdentifier, for: .touchUpInside)
    setSelected(to: false)
  }
  
  // Configure Method
  func setImage(to image: UIImage?) {
    self.imageView.image = image
  }
  
  func setSelected(to isSelected: Bool, with color: UIColor = .red01) {
    selectedBlurView.layer.borderColor = isSelected ? color.cgColor : UIColor.clear.cgColor
    selectedBlurView.layer.borderWidth = 2
    selectedBlurView.backgroundColor = isSelected ? .black01.withAlphaComponent(0.5) : .clear
    checkButton.configuration?.baseBackgroundColor = isSelected ? color : .white
    checkButton.configuration?.background.strokeColor = isSelected ? .clear : .gray03
    checkButton.isSelected = isSelected
  }
}

// Configure UI Method
private extension AssetImageGridCell {
  func configureUI() {
    configureActions()
    configureHierarchy()
    makeConstraints()
  }
  
  func configureActions() {
    let action = UIAction(identifier: actionIdentifier) { [weak self] _ in
      guard let self = self else { return }
      
      delegate?.assetImageGridCell(self)
    }
    
    checkButton.addAction(action, for: .touchUpInside)
  }
  
  func configureHierarchy() {
    [imageView, selectedBlurView, checkButton].forEach(contentView.addSubview(_:))
  }
  
  func makeConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    selectedBlurView.snp.makeConstraints {
      $0.edges.equalTo(imageView)
    }
    
    checkButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
      $0.width.height.equalTo(20)
    }
  }
}

private extension AssetImageGridCell {
  enum Constants {
    static let actionIdentifier: String = "SELECT_ACTION"
  }
}
