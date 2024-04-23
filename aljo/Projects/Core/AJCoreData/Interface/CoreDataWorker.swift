//
//  CoreDataWorkerProtocol.swift
//  AJCoreDataInterface
//
//  Created by 이태영 on 2/3/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import CoreData

public protocol CoreDataWorker: AnyObject {
  func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}
