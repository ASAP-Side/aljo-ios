//
//  ValidGroupPasswordUseCase.swift
//  GroupDomainInterface
//
//  Created by 이태영 on 5/4/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import Foundation

public protocol ValidGroupPasswordUseCase {
  func excute(with password: String) -> Bool
}
