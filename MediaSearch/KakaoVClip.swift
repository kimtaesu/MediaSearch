//
//  KakaoVClip.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

struct KakaoVClip: Decodable, Equatable {
  let id: String = UUID().uuidString
  let title: String
  let origin: String
  let thumbnail: String
  let playTime: Int
  let author: String
  let datetime: Date
  
  enum CodingKeys: String, CodingKey {
    case title
    case origin = "url"
    case thumbnail
    case datetime
    case author
    case playTime = "play_time"
  }
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    title = try values.decode(String.self, forKey: .title)
    origin = try values.decode(String.self, forKey: .origin)
    thumbnail = try values.decode(String.self, forKey: .thumbnail)
    author = try values.decode(String.self, forKey: .author)
    playTime = try values.decode(Int.self, forKey: .playTime)
    datetime = DateFormatter.iso8601Format(try values.decode(String.self, forKey: .datetime))
  }
}
