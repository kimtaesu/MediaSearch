//
//  ThumbnailView.swift
//  MediaSearch
//
//  Created by tskim on 28/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources

enum ThumbnailView: IdentifiableType, Equatable {
  static func == (lhs: ThumbnailView, rhs: ThumbnailView) -> Bool {
    switch (lhs, rhs) {
    case (.thumbnail(let l), .thumbnail(let r)):
      return l == r
    default:
      return false
    }
  }
  case thumbnail(Thumbnail)
  case loadMore
  
  var identity: String {
    switch self {
    case .thumbnail(let thumbnail):
      return thumbnail.id
    default:
      return UUID().uuidString
    }
  }
}
