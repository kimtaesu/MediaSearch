//
//  ResponseFixture.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
@testable import MediaSearch

class ResponseFixture {
  static var sortRecencyImage: KakaoImageResponse {
    return ResourcesLoader.loadJson("sort_kakao_image_recency")
  }
  static var sortAccuracyImage: KakaoImageResponse {
    return ResourcesLoader.loadJson("sort_kakao_image_accuracy")
  }
  static var sortRecencyVClip: KakaoVClipResponse {
    return ResourcesLoader.loadJson("sort_kakao_vclip_recency")
  }
  static var sortAccuracyVClip: KakaoVClipResponse {
    return ResourcesLoader.loadJson("sort_kakao_vclip_accuracy")
  }
  static var empty: KakaoImageResponse {
    return ResourcesLoader.loadJson("empty")
  }
  static var sample: KakaoImageResponse {
    return ResourcesLoader.loadJson("kakaoImageResponse")
  }
}
