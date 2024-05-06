//
//  GroupInformation.swift
//  GroupDomainInterface
//
//  Created by 이태영 on 5/6/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

public struct GroupInformation {
  public let isPublic: Bool
  public let password: String
  
  public init(isPublic: Bool, password: String) {
    self.isPublic = isPublic
    self.password = password
  }
}
