//
//  RxScheduler.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

protocol RxSchedulerType {
  var io: SchedulerType { get }
  var network: SchedulerType { get }
  var main: SchedulerType { get }
}

struct RxScheduler: RxSchedulerType {
  let network: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .utility)
  
  let io: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .utility)
  
  let main: SchedulerType = MainScheduler()
}
