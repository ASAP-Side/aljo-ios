//
//  AlarmInteractionSettingViewModel.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/15/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface

import RxCocoa
import RxSwift

final class AlarmInteractionSettingViewModel: ViewModelable {
  struct Input {
    let soundOnlyTapped: ControlEvent<Void>
    let vibrateOnlyTapped: ControlEvent<Void>
    let soundAndVibrateTapped: ControlEvent<Void>
    let volume: ControlProperty<Float>
  }
  
  struct Output {
    let isSoundOnlySelected: Driver<Bool>
    let isVibrateOnlySelected: Driver<Bool>
    let isSoundAndVibrateSelected: Driver<Bool>
    let isSoundSettingHidden: Driver<Bool>
    let isConfirmEnable: Driver<Bool>
  }
  
  func transform(to input: Input) -> Output {
    let isSoundOnlySelected = Observable.merge(
      input.soundOnlyTapped.map { _ in true },
      input.vibrateOnlyTapped.map { _ in false },
      input.soundAndVibrateTapped.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isVibrateOnlySelected = Observable.merge(
      input.soundOnlyTapped.map { _ in false },
      input.vibrateOnlyTapped.map { _ in true },
      input.soundAndVibrateTapped.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isSoundAndVibrateSelected = Observable.merge(
      input.soundOnlyTapped.map { _ in false },
      input.vibrateOnlyTapped.map { _ in false },
      input.soundAndVibrateTapped.map { _ in true }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isSoundSettingHidden = Observable.merge(
      input.soundOnlyTapped.map { _ in false },
      input.vibrateOnlyTapped.map { _ in true },
      input.soundAndVibrateTapped.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isConfirmEnable = Driver.combineLatest(
      isSoundOnlySelected,
      isVibrateOnlySelected,
      isSoundAndVibrateSelected,
      input.volume.asDriver(onErrorJustReturn: 0.0)
    ) { isSoundOnlySelected, isVibrateOnlySelected, isSoundAndVibrateSelected, volume in
      return isVibrateOnlySelected ||
      ((isSoundOnlySelected || isSoundAndVibrateSelected) && volume >= 0.1)
    }
    
    return Output(
      isSoundOnlySelected: isSoundOnlySelected,
      isVibrateOnlySelected: isVibrateOnlySelected,
      isSoundAndVibrateSelected: isSoundAndVibrateSelected,
      isSoundSettingHidden: isSoundSettingHidden,
      isConfirmEnable: isConfirmEnable
    )
  }
}
