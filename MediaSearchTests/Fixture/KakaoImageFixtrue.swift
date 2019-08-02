//
//  KakaoImageFixtrue.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
@testable import MediaSearch

class KakaoImageFixtrue {
  static var random: KakaoImage {
    return ResponseFixture.sample.documents.first!
  }
}

