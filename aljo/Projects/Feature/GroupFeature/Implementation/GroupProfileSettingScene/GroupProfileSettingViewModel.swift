//
//  GroupProfileSettingViewModel.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/9/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface

import RxCocoa
import RxSwift

final class GroupProfileSettingViewModel: ViewModelable {
  struct Input {
    let weekdayTap: Observable<Weekday>
  }
  
  struct Output {
    let selectedWeekdays: Driver<[Weekday: Bool]>
  }
  private let weekdaysSelectHistories: [Weekday: Bool] = Weekday.allCases
    .reduce(into: [:]) { initialValue, weekday in
      initialValue[weekday] = false
    }
  
  func transform(to input: Input) -> Output {
    let selectedWeekdays = input.weekdayTap
      .scan(into: weekdaysSelectHistories) { weekdaysSelectHistories, selectedWeekday in
        if let isSelected = weekdaysSelectHistories[selectedWeekday] {
          weekdaysSelectHistories[selectedWeekday] = !isSelected
        }
      }
      .asDriver(onErrorJustReturn: weekdaysSelectHistories)
    
    return Output(
      selectedWeekdays: selectedWeekdays
    )
  }
}

enum Weekday: CaseIterable {
  case monday
  case tuesday
  case wednesday
  case thursday
  case friday
  case saturday
  case sunday
}
