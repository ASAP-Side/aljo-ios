//
//  GroupInformationBuilder.swift
//  GroupDomainInterface
//
//  Created by 이태영 on 5/7/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import Foundation

public final class GroupInformationBuilder {
  private var isPublic: Bool?
  private var password: String?
  private var mainImage: Data?
  private var name: String?
  private var introduction: String?
  private var headCount: Int?
  private var weekdays: [Weekday] = []
  private var alarmTime: Date?
  private var endDate: Date?
  
  public init() { }
  
  @discardableResult
  public func setIsPublic(_ isPublic: Bool) -> Self {
    self.isPublic = isPublic
    return self
  }
  
  @discardableResult
  public func setPassword(_ password: String?) -> Self {
    self.password = password
    return self
  }
  
  @discardableResult
  public func setMainImage(_ image: Data?) -> Self {
    self.mainImage = image
    return self
  }
  
  @discardableResult
  public func setName(_ name: String) -> Self {
    self.name = name
    return self
  }
  
  @discardableResult
  public func setIntroduction(_ introduction: String) -> Self {
    self.introduction = introduction
    return self
  }
  
  @discardableResult
  public func setHeadCount(_ headCount: Int) -> Self {
    self.headCount = headCount
    return self
  }
  
  @discardableResult
  public func setWeekdays(_ weekdays: [Weekday]) -> Self {
    self.weekdays = weekdays
    return self
  }
  
  @discardableResult
  public func setAlarmTime(_ alarmTime: Date?) -> Self {
    self.alarmTime = alarmTime
    return self
  }
  
  @discardableResult
  public func setEndDate(_ endDate: Date?) -> Self {
    self.endDate = endDate
    return self
  }
  
  public func build() -> GroupInformation? {
    guard let isPublic = isPublic else {
      assert(false, "Group Privacy Missing")
      return nil
    }
    
    if isPublic == false && (password == nil || password?.count != 4) {
      assert(false, "Password Missing")
      return nil
    }
    
    return GroupInformation(isPublic: isPublic, password: password)
  }
}
