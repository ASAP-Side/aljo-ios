//
//  AlarmDismissalSelectionViewModel.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/13/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface

import RxSwift
import RxCocoa

final class AlarmDismissalSelectionViewModel: ViewModelable {
  struct Input {
    let eyeTrackingTapped: ControlEvent<Void>
    let slideToUnlockTapped: ControlEvent<Void>
  }
  
  struct Output {
    let isEyeTrackingSelected: Driver<Bool>
    let isSlideToUnlockSelected: Driver<Bool>
    let isNextEnable: Driver<Bool>
  }
  
  func transform(to input: Input) -> Output {
    let isEyeTrackingSelected = Observable.merge(
      input.eyeTrackingTapped.map { _ in true },
      input.slideToUnlockTapped.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isSlideToUnlockSelected = Observable.merge(
      input.eyeTrackingTapped.map { _ in false },
      input.slideToUnlockTapped.map { _ in true }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isNextEnable = Driver.merge(
      isEyeTrackingSelected,
      isSlideToUnlockSelected
    )
      .map { _ in true }
      .distinctUntilChanged()
    
    return Output(
      isEyeTrackingSelected: isEyeTrackingSelected,
      isSlideToUnlockSelected: isSlideToUnlockSelected,
      isNextEnable: isNextEnable
    )
  }
}
