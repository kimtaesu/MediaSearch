//
//  HasThumbnailable.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

protocol Thumbnailable {
  var id: String { get }
  var media_type: MediaType { get }
  var thumbnail_url: String { get }
  var origin_url: String { get }
  var datetime: Date { get }
  var height: Int { get }
  var width: Int { get }
}

extension Thumbnailable {
  var identity: String {
    return id
  }

  var concreateThumbnailView: ThumbnailView {
    let thumbnail = Thumbnail(
      id: self.id,
      media_type: self.media_type,
      thumbnail_url: self.thumbnail_url,
      origin_url: self.origin_url,
      datetime: self.datetime,
      height: self.height,
      width: self.width
    )
    return ThumbnailView.thumbnail(thumbnail)
  }
  
  var concreateThumbnail: Thumbnail {
    return Thumbnail(
      id: self.id,
      media_type: self.media_type,
      thumbnail_url: self.thumbnail_url,
      origin_url: self.origin_url,
      datetime: self.datetime,
      height: self.height,
      width: self.width
    )
  }
}
