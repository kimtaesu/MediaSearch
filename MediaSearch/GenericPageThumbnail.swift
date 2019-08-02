//
//  GenericPageThumbnail.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

struct GenericPageThumbnail {
  let request: ImageRequest
  let meta: Meta
  let nextPage: Int?
  let documents: [Thumbnailable]
}

extension GenericPageThumbnail {
  var curPage: Int? {
    if let next = nextPage {
      return next - 1
    } else {
      return nil
    }
  }
  var isEnd: Bool {
    return self.meta.is_end || self.meta.pageable_count == curPage
  }
}
