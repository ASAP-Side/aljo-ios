//
//  GroupPrivacySelectionViewModel.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 4/30/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import BaseFeatureInterface
import GroupDomainInterface

import RxCocoa
import RxSwift
 
final class GroupPrivacySelectionViewModel: ViewModelable {
  struct Input {
    let publicTapped: ControlEvent<Void>
    let privateTapped: ControlEvent<Void>
    let password: ControlProperty<String>
    let nextButtonTapped: ControlEvent<Void>
  }
  
  struct Output {
    let isPublicSelected: Driver<Bool>
    let isPrivateSelected: Driver<Bool>
    let passwordTitle: Driver<String>
    let isNextEnable: Driver<Bool>
    let toNext: Driver<Void>
  }
  
  private let validGroupPasswordUseCase: ValidGroupPasswordUseCase
  private weak var groupCreateCoordinator: GroupCreateCoordinator?
  
  init(
    validGroupPasswordUseCase: ValidGroupPasswordUseCase,
    groupCreateCoordinator: GroupCreateCoordinator?
  ) {
    self.validGroupPasswordUseCase = validGroupPasswordUseCase
    self.groupCreateCoordinator = groupCreateCoordinator
  }
  
  func transform(to input: Input) -> Output {
    let isPublicSelected = Observable.merge(
      input.publicTapped.map { _ in true },
      input.privateTapped.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isPrivateSelected = Observable.merge(
      input.publicTapped.map { _ in false },
      input.privateTapped.map { _ in true }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isPasswordValid = input.password
      .map { self.validGroupPasswordUseCase.excute(with: $0) }
      .asDriver(onErrorJustReturn: false)
    
    let passwordTitle = Observable.merge(
      input.password.map { $0.isEmpty ? "" : "비밀번호" },
      input.publicTapped.map { _ in "" }
    )
      .distinctUntilChanged()
    .asDriver(onErrorJustReturn: "")
    
    let isNextEnable = Driver.combineLatest(
      isPublicSelected,
      isPrivateSelected,
      isPasswordValid
    ) {
      return $0 == true || ($1 == true && $2 == true)
    }
    
    let privacyAndPassword = Observable.combineLatest(
      isPublicSelected.asObservable(),
      input.password.asObservable().startWith("")
    ) {
      return (isPublic: $0, password: $1)
    }
    
    let toNext = input.nextButtonTapped.withLatestFrom(privacyAndPassword) {
      return ($1.isPublic, $1.isPublic ? nil : $1.password)
    }
      .map { isPublic, password in
        GroupInformationBuilder()
          .setIsPublic(isPublic)
          .setPassword(password)
      }
      .do {
        self.groupCreateCoordinator?.navigateGroupProfileSetting(with: $0)
      }
      .map { _ in }
      .asDriver(onErrorJustReturn: ())
      
    return Output(
      isPublicSelected: isPublicSelected,
      isPrivateSelected: isPrivateSelected, 
      passwordTitle: passwordTitle,
      isNextEnable: isNextEnable,
      toNext: toNext
    )
  }
}
