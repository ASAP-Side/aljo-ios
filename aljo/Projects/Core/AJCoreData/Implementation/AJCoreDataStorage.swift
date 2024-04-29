//
//  DefaultCoreDataStorage.swift
//  AJCoreDataImplemenetation
//
//  Created by 이태영 on 2/3/24.
//  Copyright © 2024 com.ASAP. All rights reserved.
//

import AJCoreDataInterface
import CoreData

import RxSwift

final class AJCoreDataStorage: CoreDataStorage {
  private let worker: CoreDataWorker
  
  init(worker: CoreDataWorker = AJCoreDataWorker.default) {
    self.worker = worker
  }
  
  func fetch<Entity: ManagedObjectConvertible>(
    with predicate: NSPredicate?,
    sortDescriptors: [NSSortDescriptor]?,
    limit: Int?
  ) -> Observable<[Entity]> {
    return Observable.create { observer in
      self.worker.performBackgroundTask { context in
        do {
          let fetchRequest = Entity.ManagedObject.fetchRequest()
          fetchRequest.predicate = predicate
          fetchRequest.sortDescriptors = sortDescriptors
          if let limit = limit {
            fetchRequest.fetchLimit = limit
          }
          let results = try context.fetch(fetchRequest) as? [Entity.ManagedObject]
          let items: [Entity] = results?.compactMap { $0.toEntity() as? Entity } ?? []
          observer.onNext(items)
        } catch {
          observer.onError(CoreDataError.didNotConvertDomain)
        }
      }
      
      return Disposables.create()
    }
  }
  
  func upsert<Entity: ManagedObjectConvertible>(entities: [Entity]) -> Observable<Void> {
    return Observable.create { [weak worker] observer in
      worker?.performBackgroundTask { context in
        let _ = entities.compactMap { $0.toManagedObject(in: context) }
        
        do {
          try context.save()
          observer.onNext(())
        } catch {
          observer.onError(CoreDataError.didNotConvertDomain)
        }
      }
      
      return Disposables.create()
    }
  }
  
  func delete<Entity: ManagedObjectConvertible>(entity: Entity) -> Observable<Void>  {
    return Observable.create { [weak worker] observer in
      worker?.performBackgroundTask { context in
        let object = entity.toManagedObject(in: context)
        
        context.delete(object)
        
        do {
          try context.save()
          observer.onNext(())
        } catch {
          observer.onError(CoreDataError.didNotConvertDomain)
        }
      }
      
      return Disposables.create()
    }
  }
}
