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

public final class GroupPrivacySelectionViewModel: ViewModelable {
  public struct Input {
    let tapPublic: ControlEvent<Void>
    let tapPrivate: ControlEvent<Void>
    let password: ControlProperty<String>
  }
  
  public struct Output {
    let isPublicSelected: Driver<Bool>
    let isPrivateSelected: Driver<Bool>
    let passwordTitle: Driver<String>
    let isNextEnable: Driver<Bool>
  }
  
  private let validGroupPasswordUseCase: ValidGroupPasswordUseCase
  
  public init(
    validGroupPasswordUseCase: ValidGroupPasswordUseCase
  ) {
    self.validGroupPasswordUseCase = validGroupPasswordUseCase
  }
  
  public func transform(to input: Input) -> Output {
    let isPublicSelected = Observable.merge(
      input.tapPublic.map { _ in true },
      input.tapPrivate.map { _ in false }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isPrivateSelected = Observable.merge(
      input.tapPublic.map { _ in false },
      input.tapPrivate.map { _ in true }
    )
      .asDriver(onErrorJustReturn: false)
    
    let isPasswordValid = input.password
      .map { self.validGroupPasswordUseCase.excute(with: $0) }
      .asDriver(onErrorJustReturn: false)
    
    let passwordTitle = Observable.merge(
      input.password.map { $0.isEmpty ? "" : "비밀번호" },
      input.tapPublic.map { _ in "" }
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
    
    return Output(
      isPublicSelected: isPublicSelected,
      isPrivateSelected: isPrivateSelected, 
      passwordTitle: passwordTitle,
      isNextEnable: isNextEnable
    )
  }
}
