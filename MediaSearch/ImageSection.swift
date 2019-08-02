//
//  ThumbnailSection2.swift
//  MediaSearch
//
//  Created by tskim on 28/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources

struct ImageSection: Equatable {
  var header: String
  var items: [Item]
}

extension ImageSection: AnimatableSectionModelType {
  typealias Item = Thumbnail
  
  var identity: String {
    return header
  }
  
  init(original: ImageSection, items: [Item]) {
    self = original
    self.items = items
  }
}

extension Array where Element == ImageSection {
  func getThumbnailByIndex(_ ip: IndexPath) -> Thumbnailable {
    return self[ip.section].items[ip.row]
  }
}

extension ThumbnailSection {
  var toImageSection: ImageSection {
    let thumbnails: [Thumbnail] = self.items.compactMap {
      switch $0 {
      case .thumbnail(let thumbnail):
        return thumbnail
      default:
        return nil
      }
    }
    return ImageSection(header: self.header, items: thumbnails)
  }
}
