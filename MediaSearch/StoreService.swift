//
//  StoreService.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

class StoreService: StoreServiceType {
  let scheduler: RxSchedulerType
  
  init(scheduler: RxSchedulerType) {
    self.scheduler = scheduler
  }
  func toggle(_ image: Thumbnailable) -> Observable<Bool> {
    return Observable.deferred {
      if let first = CoreDataManager.shared.firstFavorite(id: image.id) {
        CoreDataManager.shared.delete(favorite: first)
        return .just(false)
      } else {
        CoreDataManager.shared.insertFavorite(image)
        return .just(true)
      }
    }.subscribeOn(scheduler.io)
  }

  func isExist(_ image: Thumbnailable) -> Observable<Bool> {
    return Observable.deferred {
      let first = CoreDataManager.shared.firstFavorite(id: image.id)
      return Observable.just(first != nil)
    }.subscribeOn(scheduler.io)
  }
  func fetchFavorites() -> Observable<[Thumbnailable]> {
    
    return Observable.deferred {
      return Observable.just(CoreDataManager.shared.fetchFavorites())
    }.subscribeOn(scheduler.io)
  }
}
