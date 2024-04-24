//
//  StubCoreDataWorker.swift
//  AJCoreDataTesting
//
//  Created by 이태영 on 2/3/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import AJCoreDataInterface
import CoreData

public final class StubCoreDataWorker: CoreDataWorker {
  public static let `default` = StubCoreDataWorker()
  
  lazy var persistentContainer: NSPersistentContainer = {
    guard let modelURL = Bundle(for: type(of: self)).url(forResource: "DUMMYTEST", withExtension: "momd") else {
      fatalError("Did Not Match Managed Object Model")
    }
    
    guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
      fatalError("Did Not Match Managed Object Model")
    }
    
    let container = NSPersistentContainer(name: "DUMMYTEST", managedObjectModel: mom)
    let description = NSPersistentStoreDescription()
    description.url = URL(fileURLWithPath: "/dev/null")
    container.persistentStoreDescriptions = [description]
    
    container.loadPersistentStores { description, error in
      assert(error == nil, "LoadPersistentStores Fail")
    }
    
    return container
  }()
  
  private init() { }
  
  public func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
    persistentContainer.performBackgroundTask(block)
  }
}
