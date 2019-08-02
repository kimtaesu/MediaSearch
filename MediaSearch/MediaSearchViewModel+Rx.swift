//
//  MediaSearchViewModel+Rx.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == [GenericPageThumbnail] {
  func flatten() -> Observable<[Thumbnailable]> {
    return self.map {
      $0.flatMap {
        $0.documents
      }
    }
  }
}

extension Observable where E == [Thumbnailable] {
  func sortOfThubmail() -> Observable<[ThumbnailView]> {
    return self.map { items in
      assertBackgroundThread()
      var temp = items.map { $0.concreateThumbnailView }
      temp.sort(by: { left, right -> Bool in
        switch (left, right) {
        case (.thumbnail(let l), .thumbnail(let r)):
          return l.datetime > r.datetime
        default:
          return true
        }
      })
      return temp
    }
  }
}
