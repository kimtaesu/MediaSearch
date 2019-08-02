//
//  KakaoImage.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

struct KakaoImage: Decodable, Equatable {
  let id: String = UUID().uuidString
  var thumbnail: String
  var image: String
  let collection: String
  let width: Int
  let height: Int
  let displaySiteName: String
  let doc_url: String
  let datetime: Date
  
  enum CodingKeys: String, CodingKey {
    case collection
    case width
    case height
    case doc_url
    case datetime
    case displaySiteName = "display_sitename"
    case thumbnail = "thumbnail_url"
    case origin = "image_url"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    collection = try values.decode(String.self, forKey: .collection)
    thumbnail = try values.decode(String.self, forKey: .thumbnail)
    image = try values.decode(String.self, forKey: .origin)
    width = try values.decode(Int.self, forKey: .width)
    height = try values.decode(Int.self, forKey: .height)
    displaySiteName = try values.decode(String.self, forKey: .displaySiteName)
    doc_url = try values.decode(String.self, forKey: .doc_url)
    datetime = DateFormatter.iso8601Format(try values.decode(String.self, forKey: .datetime))
  }
}
