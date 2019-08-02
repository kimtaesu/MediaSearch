//
//  KakaoVClip+Thumbnailable.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

extension KakaoVClip: Thumbnailable {
  var media_type: MediaType {
    return .vclip
  }

  var thumbnail_url: String {
    return self.thumbnail
  }

  var origin_url: String {
    return self.thumbnail
  }

  var height: Int {
    return 78
  }

  var width: Int {
    return 138
  }
}
