//
//  'ObservableType+Subscribe.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

extension ObservableType {
  func subscribeResult<T: Decodable>(
    onNext makeSuccessResult: @escaping (T) -> Void,
    onError makeErrorResult: @escaping (Error) -> Void
  ) -> Disposable where Self.E == Result<T, Error> {
    return self.subscribe(onNext: { result in
      switch result {
      case .success(let element):
        makeSuccessResult(element)
      case .failure(let error):
        makeErrorResult(error)
      }
    },
      onError: { error in
        makeErrorResult(error)
      })
  }
}
