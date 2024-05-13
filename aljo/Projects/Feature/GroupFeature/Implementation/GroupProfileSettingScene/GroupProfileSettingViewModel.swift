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
import GroupDomainInterface

import RxCocoa
import RxSwift

public protocol GroupRandomImageDelegate: AnyObject {
  func generateRandomImage()
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
    let nextTapped: ControlEvent<Void>
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
    let toNext: Driver<Void>
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
  
  private var groupInformationBuilder: GroupInformationBuilder
  
  private var randomImage: UIImage {
    // TODO: 랜덤한 이미지 생성 로직 구현
    return .AJImage.group_random1
  }
  
  init(
    coordinator: GroupCreateCoordinator?,
    groupInformationBuilder: GroupInformationBuilder
  ) {
    self.coordinator = coordinator
    self.groupInformationBuilder = groupInformationBuilder
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
    
    let selectedImage = Observable.merge(
      selectedImageRelay.compactMap { $0.first },
      randomImageRelay.asObservable()
    )
      .startWith(randomImage)
      .asDriver(onErrorJustReturn: UIImage())
    
    let requiredSettings = Driver.combineLatest(
      input.groupName.asDriver(onErrorJustReturn: ""),
      input.groupIntroduce.asDriver(onErrorJustReturn: ""),
      input.headCount.asDriver(onErrorJustReturn: 0),
      input.endDate.asDriver(onErrorJustReturn: Date()),
      selectedWeekdays,
      selectedDateRelay.asDriver(onErrorJustReturn: nil),
      selectedImage.map { $0?.pngData() }
    ) {
      return (
        groupName: $0,
        groupIntroduce: $1,
        headCount: $2,
        endDate: $3,
        selectedWeekdays: $4.filter { $0.value != false }.map { $0.key },
        selectedDate: $5,
        selectedImage: $6
      )
    }
    
    let isNextEnable = requiredSettings
      .map { settings in
        return !settings.groupName.isEmpty
        && !settings.groupIntroduce.isEmpty
        && settings.headCount > 0
        && settings.endDate != nil
        && settings.selectedDate != nil
        && !(settings.selectedWeekdays.isEmpty)
      }
    
    let toNext = input.nextTapped.withLatestFrom(requiredSettings)
      .map {
        self.groupInformationBuilder
          .setMainImage($0.selectedImage)
          .setName($0.groupName)
          .setIntroduction($0.groupIntroduce)
          .setHeadCount($0.headCount)
          .setWeekdays($0.selectedWeekdays)
          .setAlarmTime($0.selectedDate)
          .setEndDate($0.endDate)
      }
      .do(onNext: {
        // TODO: 세팅값 전달은 추후에 기획 완성되면 구현 예정
        self.coordinator?.navigateAlarmDismissalSelectionViewController()
      })
      .map { _ in }
      .asDriver(onErrorJustReturn: ())
    
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
      isNextEnable: isNextEnable,
      toNext: toNext
    )
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

extension GroupProfileSettingViewModel: GroupRandomImageDelegate {
  func generateRandomImage() {
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
