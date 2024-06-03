//
//  PrivacyButton+Rx.swift
//  GroupFeatureImplementation
//
//  Created by 이태영 on 4/29/24.
//  Copyright © 2024 com.asap. All rights reserved.
//

import RxCocoa
import RxSwift

extension Reactive where Base: PrivacyButton {
  var tap: ControlEvent<Void> {
    controlEvent(.touchUpInside)
  }
}
