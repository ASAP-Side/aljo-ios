//
//  AlarmDismissalSelectionViewController.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/13/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

import RxSwift
import RxCocoa
import SnapKit

public final class AlarmDismissalSelectionViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private let viewModel: AlarmDismissalSelectionViewModel
  
  // MARK: Components
  private let titleLabel: UILabel = {
    let label = UILabel()
    // TODO: 닉네임 동적으로 변경
    label.text = "아삽아삽님만의 알람 방식을\n선택해주세요!"
    label.textColor = .black01
    label.font = .pretendard(.headLine1)
    label.numberOfLines = 0
    return label
  }()
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .AJImage.group_bell
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let eyeTrackingButton = DissmisalContentButton(
    image: UIImage.Icon.eye_tracking,
    title: "목표물을 응시해서 알람 해제"
  )
  
  private let slideToUnlockButton = DissmisalContentButton(
    image: UIImage.Icon.slide_to_unlock,
    title: "밀어서 알람 해제"
  )
  
  private let nextButton: UIButton = {
    let button = ASRectButton(style: .fill)
    button.title = "다음"
    button.isEnabled = false
    return button
  }()
  
  init(viewModel: AlarmDismissalSelectionViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable, message: "스토리 보드로 생성할 수 없습니다.")
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public override func viewDidLoad() {
    configureUI()
    bind()
  }
  
  private func bind() {
    let input = AlarmDismissalSelectionViewModel.Input(
      eyeTrackingTapped: eyeTrackingButton.rx.tap,
      slideToUnlockTapped: slideToUnlockButton.rx.tap
    )
    
    let output = viewModel.transform(to: input)
    
    output.isEyeTrackingSelected
      .drive(eyeTrackingButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isSlideToUnlockSelected
      .drive(slideToUnlockButton.rx.isSelected)
      .disposed(by: disposeBag)
    
    output.isNextEnable
      .drive(nextButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }
}

// MARK: Configure UI
extension AlarmDismissalSelectionViewController {
  private func configureUI() {
    view.backgroundColor = .systemBackground
    configureHierarchy()
    configureConstraints()
  }
  
  private func configureHierarchy() {
    [
      titleLabel,
      imageView,
      eyeTrackingButton,
      slideToUnlockButton,
      nextButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  private func configureConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
    }
    
    imageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(view.frame.height * 0.125)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(view.snp.height).multipliedBy(0.2)
    }
    
    eyeTrackingButton.snp.makeConstraints {
      $0.height.equalToSuperview().multipliedBy(0.085)
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(slideToUnlockButton.snp.top).offset(-8)
    }
    
    slideToUnlockButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      
      $0.bottom.equalTo(nextButton.snp.top).offset(-20)
      $0.height.equalToSuperview().multipliedBy(0.085)
    }
    
    nextButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        .inset(safeAreaBottomInset())
      $0.height.equalTo(view.snp.height).multipliedBy(0.065)
    }
  }
  
  private func safeAreaBottomInset() -> CGFloat {
      let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
      if scene?.windows.first?.safeAreaInsets.bottom == 0 {
        return 20
      }
      
      return .zero
    }
}
