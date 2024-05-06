//
//  GroupInformationBuilder.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/6/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import GroupDomainInterface

public final class GroupInformationBuilder {
  private var isPublic: Bool?
  private var password: String?
  
  func setIsPublic(_ isPublic: Bool?) -> Self {
    self.isPublic = isPublic
    return self
  }
  
  func setPassword(_ password: String?) -> Self {
    self.password = password
    return self
  }
  
  func build() -> GroupInformation? {
    guard let isPublic = isPublic else {
      assert(false, "Group Privacy Missing")
      return nil
    }
    
    guard let password = password else {
      assert(false, "Password Missing")
      return nil
    }
    
    return GroupInformation(isPublic: isPublic, password: password)
  }
}
