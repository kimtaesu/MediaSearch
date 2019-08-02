//
//  ImageRequest.swift
//  MediaSearch
//
//  Created by tskim on 22/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

enum ImageRequest {
  case image(KakaoImageRequest)
  case vclip(KakaoVClipRequest)
}

extension ImageRequest: Hashable, Equatable {

  static func == (lhs: ImageRequest, rhs: ImageRequest) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }

  func hash(into hasher: inout Hasher) {
    switch self {
    case .image: hasher.combine(0)
    case .vclip: hasher.combine(1)
    }
  }
}
