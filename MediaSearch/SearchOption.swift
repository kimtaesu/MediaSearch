//
//  Requests.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

struct SearchOption: Codable {
  static let PAGE_SIZE = 10
  
  enum SortType: String {
    case accuracy
    case recency
  }

  let query: String
  let sort: String
  var page: Int
  let size: Int

  public init(query: String, page: Int = 1, size: Int = PAGE_SIZE, sort: SortType = SortType.recency) {
    self.query = query
    self.sort = sort.rawValue
    self.page = page
    self.size = size
  }
}
