//
//  Coordinator.swift
//  FlowKitInterface
//
//  Created by 이태영 on 3/20/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//
import UIKit

public protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }

  func start()
}
