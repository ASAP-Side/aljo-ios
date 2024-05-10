//
//  AlarmTimePicker.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/10/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit

final class AlarmTimePicker: UIView {
  enum Constant {
    static let timePeriod = 0
    static let hour = 1
    static let minute = 2
    static let maxRowCount = 100000
  }
  
  private let pickerView = UIPickerView()
  private let colonLabel: UILabel = {
    let label = UILabel()
    label.font = .pretendard(.headLine3)
    label.text = ":"
    label.textColor = .black01
    label.textAlignment = .center
    return label
  }()
  
  private let timePeriodOptions = ["오전", "오후"]
  private let hourOptions = Array(1...12)
  private let minuteOptions = stride(from: 0, through: 59, by: 5).map {
    String(format: "%02d", $0)
  }
  
  var selectedtimePeriod: String = "오전"
  var selectedHour: Int = 1
  var selectedMinute: Int = 0
  
  init(startDate: Date = Date()) {
    super.init(frame: .zero)
    setupPickerView(startDate: startDate)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    configureColon()
  }
  
  private func configureColon() {
    let centerView = pickerView.subviews[1]
    let componentWidth = bounds.width * 0.25
    let spacing = (pickerView.bounds.width - (componentWidth * 3)) / 2
    
    let offset = (componentWidth * 2) + spacing
    
    pickerView.addSubview(colonLabel)
    
    colonLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(offset)
      $0.centerY.equalTo(centerView.snp.centerY).offset(-2)
    }
  }
  
  private func setupPickerView(startDate: Date) {
    pickerView.dataSource = self
    pickerView.delegate = self
    
    addSubview(pickerView)
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
      pickerView.topAnchor.constraint(equalTo: topAnchor),
      pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
    
    setInitialValues(startDate: startDate)
  }
  
  private func setInitialValues(startDate: Date) {
    let calendar = Calendar.current
    let hour = (calendar.component(.hour, from: startDate) + 11) % 12 + 1
    let minute = calendar.component(.minute, from: startDate)
    let timePeriod = hour >= 12 ? "오후" : "오전"
    
    selectedtimePeriod = timePeriod
    selectedHour = hour
    selectedMinute = minute
    
    pickerView.selectRow(
      timePeriodOptions.firstIndex(of: timePeriod) ?? 0,
      inComponent: Constant.timePeriod,
      animated: false
    )
    pickerView.selectRow(
      49992 + (hour - 1),
      inComponent: Constant.hour,
      animated: false
    )
    pickerView.selectRow(
      49992 + (minute / 5),
      inComponent: Constant.minute,
      animated: false
    )
  }
}

extension AlarmTimePicker: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 3
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    switch component {
    case Constant.timePeriod:
      return timePeriodOptions.count
    case Constant.hour:
      return Constant.maxRowCount
    case Constant.minute:
      return Constant.maxRowCount
    default:
      assert(false, "component count out of range")
      return 0
    }
  }
}

extension AlarmTimePicker: UIPickerViewDelegate {
  func pickerView(
    _ pickerView: UIPickerView,
    viewForRow row: Int,
    forComponent component: Int,
    reusing view: UIView?
  ) -> UIView {
    let label = UILabel()
    label.font = .pretendard(.headLine3)
    label.textColor = .black01
    label.textAlignment = .center
    
    switch component {
    case Constant.timePeriod:
      label.text = timePeriodOptions[row]
    case Constant.hour:
      label.text = hourOptions[row % hourOptions.count].description
    case Constant.minute:
      label.text = minuteOptions[row % minuteOptions.count]
    default:
      assert(false, "component count out of range")
      break
    }
    return label
  }
  
  // TODO: AM, PM 전환해주는 로직 구현
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    switch component {
    case Constant.timePeriod:
      selectedtimePeriod = timePeriodOptions[row]
    case Constant.hour:
      selectedHour = hourOptions[row % hourOptions.count]
    case Constant.minute:
      selectedMinute = Int(minuteOptions[row % minuteOptions.count]) ?? 0
    default:
      break
    }
  }
  
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return bounds.width * 0.25
  }
  
  func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
    return bounds.height * 0.13
  }
}
