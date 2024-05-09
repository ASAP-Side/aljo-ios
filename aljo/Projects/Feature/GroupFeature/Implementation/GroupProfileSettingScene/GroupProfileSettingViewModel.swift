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
    let mondayTapped: ControlEvent<Void>
    let tuesdayTapped: ControlEvent<Void>
    let wednesdayTapped: ControlEvent<Void>
    let thursdayTapped: ControlEvent<Void>
    let fridayTapped: ControlEvent<Void>
    let saturdayTapped: ControlEvent<Void>
    let sundayTapped: ControlEvent<Void>
  }
  
  struct Output {
    let isMondaySelected: Driver<Bool>
    let isTuesdaySelected: Driver<Bool>
    let isWednesdaySelected: Driver<Bool>
    let isThursdaySelected: Driver<Bool>
    let isFridaySelected: Driver<Bool>
    let isSaturdaySelected: Driver<Bool>
    let isSundaySelected: Driver<Bool>
  }
  private let weekdaysSelectHistories: [Weekday: Bool] = Weekday.allCases
    .reduce(into: [:]) { initialValue, weekday in
      initialValue[weekday] = false
    }
  
  func transform(to input: Input) -> Output {
    let selectedWeekdays = Observable.merge(
      input.mondayTapped.map { _ in Weekday.monday },
      input.tuesdayTapped.map { _ in Weekday.tuesday },
      input.wednesdayTapped.map { _ in Weekday.wednesday },
      input.thursdayTapped.map { _ in Weekday.thursday },
      input.fridayTapped.map { _ in Weekday.friday },
      input.saturdayTapped.map { _ in Weekday.saturday },
      input.sundayTapped.map { _ in Weekday.sunday }
    )
      .scan(into: weekdaysSelectHistories) { weekdaysSelectHistories, selectedWeekday in
        if let isSelected = weekdaysSelectHistories[selectedWeekday] {
          weekdaysSelectHistories[selectedWeekday] = !isSelected
        }
      }
      .asDriver(onErrorJustReturn: weekdaysSelectHistories)
    
    return Output(
      isMondaySelected: selectedWeekdays.compactMap { $0[.monday] },
      isTuesdaySelected: selectedWeekdays.compactMap { $0[.tuesday] },
      isWednesdaySelected: selectedWeekdays.compactMap { $0[.wednesday] },
      isThursdaySelected: selectedWeekdays.compactMap { $0[.thursday] },
      isFridaySelected: selectedWeekdays.compactMap { $0[.friday] },
      isSaturdaySelected: selectedWeekdays.compactMap { $0[.saturday] },
      isSundaySelected: selectedWeekdays.compactMap { $0[.sunday] }
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
