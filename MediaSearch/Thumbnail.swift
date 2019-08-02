//
//  Thumbnail.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxDataSources

struct Thumbnail: Thumbnailable, Equatable, IdentifiableType {
  let id: String
  let media_type: MediaType
  let thumbnail_url: String
  let origin_url: String
  let datetime: Date
  let height: Int
  let width: Int

  public init(id: String = UUID().uuidString, media_type: MediaType, thumbnail_url: String, origin_url: String, datetime: Date, height: Int, width: Int) {
    self.id = id
    self.media_type = media_type
    self.thumbnail_url = thumbnail_url
    self.origin_url = origin_url
    self.datetime = datetime
    self.height = height
    self.width = width
  }
}
