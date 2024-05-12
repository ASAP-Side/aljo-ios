//
//  GroupProfileSettingViewModel.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/9/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import UIKit

import ASAPKit
import BaseFeatureInterface

import RxCocoa
import RxSwift

public protocol GroupProfileRandomImageDelegate {
  func selectRandomImage()
}

final class GroupProfileSettingViewModel: ViewModelable {
  struct Input {
    let imageSelectTapped: ControlEvent<Void>
    let groupName: ControlProperty<String>
    let groupIntroduce: ControlProperty<String>
    let headCount: ControlProperty<Int>
    let mondayTapped: ControlEvent<Void>
    let tuesdayTapped: ControlEvent<Void>
    let wednesdayTapped: ControlEvent<Void>
    let thursdayTapped: ControlEvent<Void>
    let fridayTapped: ControlEvent<Void>
    let saturdayTapped: ControlEvent<Void>
    let sundayTapped: ControlEvent<Void>
    let alarmTimePickTapped: Observable<Void>
    let endDate: Observable<Date?>
  }
  
  struct Output {
    let selectedImage: Driver<UIImage?>
    let isMondaySelected: Driver<Bool>
    let isTuesdaySelected: Driver<Bool>
    let isWednesdaySelected: Driver<Bool>
    let isThursdaySelected: Driver<Bool>
    let isFridaySelected: Driver<Bool>
    let isSaturdaySelected: Driver<Bool>
    let isSundaySelected: Driver<Bool>
    let toImagePicker: Driver<Void>
    let toTimePicker: Driver<Void>
    let selectedDate: Driver<String>
    let isNextEnable: Driver<Bool>
  }
  private let weekdaysSelectHistories: [Weekday: Bool] = Weekday.allCases
    .reduce(into: [:]) { initialValue, weekday in
      initialValue[weekday] = false
    }
  private weak var coordinator: GroupCreateCoordinator?
  private let selectedImageRelay = PublishRelay<[UIImage?]>()
  private let randomImageRelay = PublishRelay<UIImage?>()
  private let selectedDateRelay = BehaviorRelay<Date?>(value: nil)
  private let dateFormatter: DateFormatter = {
    // TODO: DateFormatter Extension으로 분리
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR")
    dateFormatter.dateFormat = "a h:mm"
    return dateFormatter
  }()
  
  init(coordinator: GroupCreateCoordinator?) {
    self.coordinator = coordinator
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
    
    let toImagePicker = input.imageSelectTapped
      .do(onNext: {
        self.coordinator?.presentImagePickMenu(delegate: self)
      })
      .asDriver(onErrorJustReturn: ())
    
    let toTimePicker = input.alarmTimePickTapped
      .do(onNext: {
        self.coordinator?.presentTimeSelect(
          delegate: self,
          date: self.selectedDateRelay.value
        )
      })
      .asDriver(onErrorJustReturn: ())
    
    let selectedDate = selectedDateRelay.compactMap { $0 }
      .map { self.dateFormatter.string(from: $0) }
      .asDriver(onErrorJustReturn: "")
    
    let isNextEnable = Driver.combineLatest(
      input.groupName.asDriver(onErrorJustReturn: ""),
      input.groupIntroduce.asDriver(onErrorJustReturn: ""),
      input.headCount.asDriver(onErrorJustReturn: 0),
      input.endDate.asDriver(onErrorJustReturn: Date()),
      selectedWeekdays,
      selectedDate
    ) { groupName, groupIntroduce, headCount, endDate, selectedWeekdays, selectedDate in
      return !groupName.isEmpty
      && !groupIntroduce.isEmpty
      && headCount > 0
      && endDate != nil
      && !selectedDate.isEmpty
      && !(selectedWeekdays.filter { $0.value != false }.isEmpty)
    }

    let selectedImage = Observable.merge(
      selectedImageRelay.compactMap { $0.first },
      randomImageRelay.asObservable()
    )
      .startWith(generateRandomImage())
      .asDriver(onErrorJustReturn: UIImage())
    
    return Output(
      selectedImage: selectedImage,
      isMondaySelected: selectedWeekdays.compactMap { $0[.monday] },
      isTuesdaySelected: selectedWeekdays.compactMap { $0[.tuesday] },
      isWednesdaySelected: selectedWeekdays.compactMap { $0[.wednesday] },
      isThursdaySelected: selectedWeekdays.compactMap { $0[.thursday] },
      isFridaySelected: selectedWeekdays.compactMap { $0[.friday] },
      isSaturdaySelected: selectedWeekdays.compactMap { $0[.saturday] },
      isSundaySelected: selectedWeekdays.compactMap { $0[.sunday] },
      toImagePicker: toImagePicker,
      toTimePicker: toTimePicker,
      selectedDate: selectedDate,
      isNextEnable: isNextEnable
    )
  }
  
  private func generateRandomImage() -> UIImage {
    // TODO: 랜덤한 이미지 생성 로직 구현
    return .AJImage.group_random1
  }
}

extension GroupProfileSettingViewModel: ASImagePickerDelegate {
  func imagePicker(
    _ picker: ASImagePickerViewController,
    didComplete images: [UIImage?]
  ) {
    selectedImageRelay.accept(images)
  }
}

extension GroupProfileSettingViewModel: GroupProfileRandomImageDelegate {
  func selectRandomImage() {
    let randomImage = generateRandomImage()
    randomImageRelay.accept(randomImage)
  }
}

extension GroupProfileSettingViewModel: TimePickerBottomSheetDelegate {
  func timePickerBottomSheet(
    _ controller: TimePickerBottomSheetController,
    didComplete date: Date?
  ) {
    selectedDateRelay.accept(date)
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
