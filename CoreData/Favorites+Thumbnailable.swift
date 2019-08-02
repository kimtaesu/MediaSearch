//
//  Favorites+HasThumbnailable.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

extension Favorites: Thumbnailable {
  var datetime: Date {
    guard let date = self.o_datetime as Date? else { return Date() }
    return date
  }
  
  var height: Int {
    return Int(self.o_height)
  }
  
  var width: Int {
    return Int(self.o_width)
  }
  
  var media_type: MediaType {
    return MediaType(rawValue: Int(self.o_media_type)) ?? .image
  }

  var thumbnail_url: String {
    return self.thumbnail ?? ""
  }

  var origin_url: String {
    return self.origin ?? ""
  }
  var id: String {
    return self.o_id ?? UUID().uuidString
  }
  
  class func classString() -> String {
    return NSStringFromClass(self)
  }
}
