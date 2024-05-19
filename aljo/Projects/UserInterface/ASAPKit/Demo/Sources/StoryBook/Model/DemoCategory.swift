//
//  DemoCategory.swift
//  ASAPKitDemo
//
//  Copyright (c) 2024 Minii All rights reserved.

import UIKit

import ASAPKit

enum DemoCategory: Int, CustomStringConvertible, CaseIterable {
  case systemConfiguration
  case component
  case container
  case controller
  
  var description: String {
    switch self {
      case .systemConfiguration:
        return "시스템 설정"
      case .component:
        return "COMPONENTS"
      case .container:
        return "CONTAINER"
      case .controller:
        return "CONTROLLER"
    }
  }
  
  static var allCaseDictionary: [Self: [DemoDetail]] {
    var dictionary = [Self: [DemoDetail]]()
    
    allCases.forEach {
      switch $0 {
        case .systemConfiguration:
          dictionary.updateValue(SystemConfiguration.allCases, forKey: $0)
        case .component:
          dictionary.updateValue(ComponentsCategory.allCases, forKey: $0)
        case .container:
          dictionary.updateValue(ContainerCategory.allCases, forKey: $0)
        case .controller:
          dictionary.updateValue(ControllerCategory.allCases, forKey: $0)
      }
    }
    return dictionary
  }
}

protocol DemoDetail {
  var instance: UIViewController { get }
}

enum SystemConfiguration: DemoDetail, CustomStringConvertible, CaseIterable {
  case font
  case color
  case icon
  
  var description: String {
    switch self {
      case .font:
        return "폰트"
      case .color:
        return "색상"
      case .icon:
        return "아이콘"
    }
  }
  
  var instance: UIViewController {
    switch self {
      case .font:
        return FontStoryViewController()
      case .color:
        return ColorStoryViewController()
      case .icon:
        return IconStoryViewController()
    }
  }
}

enum ComponentsCategory: DemoDetail, CustomStringConvertible, CaseIterable {
  case textField
  case textView
  case rectButton
  case roundButton
  case stepper
  case slider
  case alarmSetting
  
  var description: String {
    switch self {
      case .textField:
        return "TextField"
      case .textView:
        return "TextView"
      case .roundButton:
        return "RoundButton"
      case .rectButton:
        return "RectangleButton"
      case .slider:
        return "Slider"
      case .stepper:
        return "Stepper"
      case .alarmSetting:
        return "AlarmSetting"
    }
  }
  
  var instance: UIViewController {
    switch self {
      case .textField:
        return ASTextFieldDemoController()
      case .textView:
        return ASTextViewDemoController()
      case .roundButton:
        return ASRoundButtonDemoController()
      case .rectButton:
        return ASRectButtonDemoController()
      case .slider:
        return ASSliderDemoController()
      case .stepper:
        return ASStepperDemoController()
      case .alarmSetting:
        return ASAlarmSettingDemoController()
    }
  }
}

enum ContainerCategory: DemoDetail, CustomStringConvertible, CaseIterable {
  case listView
  case calendarView
  
  var description: String {
    switch self {
      case .listView:
        return "ASListView"
        case .calendarView:
          return "CalendarView"
    }
  }
  
  var instance: UIViewController {
    switch self {
      case .listView:
        return ASListViewDemoController()
        case .calendarView:
          return ASCalendarDemoController()
    }
  }
}

enum ControllerCategory: DemoDetail, CustomStringConvertible, CaseIterable {
  case bottomSheet
  case imagePicker
  case alert
  
  var description: String {
    switch self {
      case .bottomSheet:
        return "ASBottomSheet"
      case .imagePicker:
        return "ASImagePicker"
      case .alert:
        return "ASAlert"
    }
  }
  
  var instance: UIViewController {
    switch self {
      case .bottomSheet:
        return ASBottomSheetDemoController()
      case .imagePicker:
        return ASImagePickerDemoController()
      case .alert:
        return ASAlertDemoController()
    }
  }
}
