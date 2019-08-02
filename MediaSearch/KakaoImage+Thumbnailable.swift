//
//  KakaoImage+Thumbnailable.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

extension KakaoImage: Thumbnailable {
  var media_type: MediaType {
    return .image
  }

  var thumbnail_url: String {
    return thumbnail
  }

  var origin_url: String {
    return image
  }
}
