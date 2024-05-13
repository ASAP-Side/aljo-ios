//
//  GroupDemoRootViewController.swift
//  GroupFeatureDemo
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import GroupFeatureImplementation
import GroupDomainInterface

import SnapKit

private enum GroupScene: CaseIterable {
  case createFull
  case privacySelection
  case profileSetting
  case dismissalSelection
  
  var title: String {
    switch self {
    case .createFull:
      return "생성 전체 플로우"
    case .privacySelection:
      return "그룹 공개 범위 설정화면"
    case .profileSetting:
      return "그룹 정보 설정화면"
    case .dismissalSelection:
      return "알람 해제 컨텐츠 설정화면"
    }
  }
}

final class GroupDemoRootViewController: UIViewController {
  weak var coordinator: GroupCreateDemoCoordinator?
  
  private let noticeLabel: UILabel = {
    let label = UILabel()
    label.text = "전체 플로우 이외에는 해당 화면의 UI 및 동작만 체크하는게 좋습니다."
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.numberOfLines = 0
    return label
  }()
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(
      UITableViewCell.self,
      forCellReuseIdentifier: "cell"
    )
    tableView.separatorInset.left = 0
    return tableView
  }()
  
  override func viewDidLoad() {
    tableView.dataSource = self
    tableView.delegate = self
    
    view.addSubview(tableView)
    view.addSubview(noticeLabel)
    
    noticeLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview().inset(20)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(noticeLabel.snp.bottom).offset(10)
      $0.horizontalEdges.bottom.equalToSuperview()
    }
  }
}

extension GroupDemoRootViewController: UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    return GroupScene.allCases.count
  }
  
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = GroupScene.allCases[indexPath.row].title
    
    return cell
  }
}

extension GroupDemoRootViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch GroupScene.allCases[indexPath.row] {
    case .createFull:
      coordinator?.navigateGroupPrivacySelection()
    case .dismissalSelection:
      coordinator?.navigateDismissalSelection()
    case .privacySelection:
      coordinator?.navigateGroupPrivacySelection()
    case .profileSetting:
      coordinator?.navigateGroupProfileSetting()
    }
  }
}

final class GroupCreateDemoCoordinator {
  private var childCoordinator: [GroupCreateCoordinator] = []
  private let window: UIWindow?
  private let navigationController = ProgressNavigationViewController()
  
  init(window: UIWindow?) {
    self.window = window
  }
  
  func start() {
    let controller = GroupDemoRootViewController()
    controller.coordinator = self
    navigationController.viewControllers = [controller]
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()
  }
  
  func navigateGroupPrivacySelection() {
    let coordinator = AJGroupCreateCoordinator(
      navigationController: navigationController
    )
    navigationController.stepCount = 4
    coordinator.start()
    childCoordinator.append(coordinator)
  }
  
  func navigateGroupProfileSetting() {
    let coordinator = AJGroupCreateCoordinator(
      navigationController: navigationController
    )
    
    navigationController.stepCount = nil
    coordinator.navigateGroupProfileSetting(with: GroupInformationBuilder())
    childCoordinator.append(coordinator)
  }
   
  func navigateDismissalSelection() {
    let coordinator = AJGroupCreateCoordinator(
      navigationController: navigationController
    )
    
    navigationController.stepCount = nil
    coordinator.navigateAlarmDismissalSelectionViewController()
    childCoordinator.append(coordinator)
  }
}
