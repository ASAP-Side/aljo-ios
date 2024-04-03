//
//  ASImagePickerDemoController.swift
//  ASAPKit
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import ASAPKit

class ASImagePickerDemoController: ComponentViewController {
  private let listView = ASListView()
  private let colorPickerButton: ASRectButton = {
    let button = ASRectButton(style: .fill)
    button.title = "색상 선택"
    return button
  }()
  
  private let presentButton: RoundButton = {
    let button = RoundButton(style: .text)
    button.title = "이미지 선택창으로"
    return button
  }()
  
  private var selectedColor: UIColor = .black
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let presentAction = UIAction { [weak self] _ in
      guard let self = self else { return }
      
      let controller = ASImagePickerViewController(max: 2, selectedColor: self.selectedColor)
      controller.delegate = self
      let navigationController = UINavigationController(rootViewController: controller)
      navigationController.modalPresentationStyle = .fullScreen
      self.present(navigationController, animated: true)
    }
    presentButton.addAction(presentAction, for: .touchUpInside)
    
    let presentPickerAction = UIAction { [weak self] _ in
      guard let self = self else { return }
      
      let controller = UIColorPickerViewController()
      controller.selectedColor = selectedColor
      controller.delegate = self
      self.present(controller, animated: true)
    }
    colorPickerButton.addAction(presentPickerAction, for: .touchUpInside)
    
    configureUI()
  }
}

extension ASImagePickerDemoController: ASImagePickerDelegate {
  func imagePicker(_ picker: ASImagePickerViewController, didComplete images: [UIImage?]) {
    print(images)
    images.forEach {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.image = $0
      listView.addItem(imageView)
    }
  }
}

extension ASImagePickerDemoController: UIColorPickerViewControllerDelegate {
  func colorPickerViewController(
    _ viewController: UIColorPickerViewController,
    didSelect color: UIColor,
    continuously: Bool
  ) {
    print(#function)
    self.selectedColor = color
  }
}

private extension ASImagePickerDemoController {
  func configureUI() {
    configureHierarchy()
    makeConstraints()
  }
  
  func configureHierarchy() {
    [listView, presentButton, colorPickerButton].forEach(view.addSubview(_:))
  }
  
  func makeConstraints() {
    presentButton.snp.makeConstraints {
      $0.horizontalEdges.equalToSuperview().inset(16)
      $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-24)
    }
    
    colorPickerButton.snp.makeConstraints {
      $0.bottom.equalTo(presentButton.snp.top).offset(-24)
      $0.horizontalEdges.equalTo(presentButton)
    }
    
    listView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.horizontalEdges.equalToSuperview()
      $0.bottom.equalTo(colorPickerButton.snp.top).offset(-24)
    }
  }
}
