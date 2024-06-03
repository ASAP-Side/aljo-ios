//
//  MenuListBottomSheetController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/12/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import SnapKit

final class MenuListBottomSheetController: ASBottomSheetController {
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "프로필 변경"
    label.font = .pretendard(.headLine3)
    label.textColor = .black01
    return label
  }()
  
  private let dismissButton: UIButton = {
    var configuration = UIButton.Configuration.plain()
    configuration.image = .Icon.xmark_black
    let button = UIButton()
    button.configuration = configuration
    return button
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      MenuListCell.self,
      forCellReuseIdentifier: "cell"
    )
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    return tableView
  }()
  
  private let contents: [MenuListCellContent]
  
  init(title: String, detent: ASBottomSheetDetent, contents: [MenuListCellContent]) {
    self.contents = contents
    super.init(detent: detent)
    titleLabel.text = title
  }
  
  override func viewDidLoad() {
    configureUI()
    configureAction()
  }
}

// MARK: UITableViewDelegate
extension MenuListBottomSheetController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    tableView.deselectRow(at: indexPath, animated: true)
    self.dismiss(animated: true)
    contents[indexPath.row].action()
  }
}

// MARK: UITableViewDataSource
extension MenuListBottomSheetController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return contents.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "cell",
      for: indexPath
    ) as? MenuListCell else {
      return .init()
    }
    
    cell.configureCell(with: contents[indexPath.row])
    return cell
  }
}

// MARK: Configure Action
extension MenuListBottomSheetController {
  private func configureAction() {
    let dismissAction = UIAction { [weak self] _ in
      self?.dismiss(animated: true)
    }
    
    dismissButton.addAction(dismissAction, for: .touchUpInside)
  }
}

// MARK: Configure UI
extension MenuListBottomSheetController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    view.layer.cornerRadius = 20
    configureHierarchy()
    configureConstraints()
    
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func configureHierarchy() {
    [titleLabel, dismissButton, tableView].forEach {
      view.addSubview($0)
    }
  }
  
  private func configureConstraints() {
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.equalToSuperview().offset(20)
    }
    
    dismissButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel.snp.centerY)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(28)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
}
