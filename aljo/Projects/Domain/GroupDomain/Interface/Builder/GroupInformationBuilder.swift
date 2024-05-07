//
//  GroupInformationBuilder.swift
//  GroupDomainInterface
//
//  Created by 이태영 on 5/7/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

public final class GroupInformationBuilder {
  private var isPublic: Bool?
  private var password: String?
  
  public init() { }
  
  public func setIsPublic(_ isPublic: Bool?) -> Self {
    self.isPublic = isPublic
    return self
  }
  
  public func setPassword(_ password: String?) -> Self {
    self.password = password
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
