//
//  ThumbnailSection.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources

struct ThumbnailSection: Equatable {
  var header: String
  var items: [Item]
}

extension ThumbnailSection: AnimatableSectionModelType {
  typealias Item = ThumbnailView

  var identity: String {
    return header
  }

  init(original: ThumbnailSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension Array where Element == ThumbnailSection {
  func getThumbnailByIndex(_ ip: IndexPath) -> ThumbnailView {
    return self[ip.section].items[ip.row]
  }
}
