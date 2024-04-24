//
//  AJCoreDataWorker.swift
//  AJCoreDataImplemenetation
//
//  Created by 이태영 on 2/3/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import AJCoreDataInterface
import CoreData

final class AJCoreDataWorker: CoreDataWorker {
  static let `default` = AJCoreDataWorker()
  
  private let persistentContainer: NSPersistentContainer
  
  private init() {
    self.persistentContainer = {
      let container = NSPersistentContainer(name: "ALJO_MODEL")
      
      container.loadPersistentStores { description, error in
        if let error = error {
          assert(true, "코어데이터를 저장소를 불러오지 못했습니다.")
        }
      }
      
      return container
    }()
  }
  
  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask(block)
  }
}
