//
//  DissmisalContentButton+Rx.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 5/13/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import Foundation

import RxCocoa
import RxSwift

extension Reactive where Base: DissmisalContentButton {
  var tap: ControlEvent<Void> {
    controlEvent(.touchUpInside)
  }
}
