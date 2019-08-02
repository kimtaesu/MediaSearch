//
//  KakaoDataSourceFixtrue.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import Cuckoo
import RxSwift

@testable import MediaSearch

extension MockKakaoServiceType {
  func setMocking(expect data: KakaoImageResponse? = nil) {
    stub(self, block: { mock in
      let mockData = data ?? ResponseFixture.sample
      let imageSample: KakaoImageResponse = mockData

      when(mock.nextImages(any(), requests: any()))
        .then { _ -> Observable<[GenericPageThumbnail]> in
          let items = [GenericPageThumbnail(request: .image(KakaoImageRequest()), meta: imageSample.meta, nextPage: imageSample.nextPage, documents: imageSample.documents)]
          return Observable.just(items)
        }
    })
  }
  func setFailure(_ reason: String? = nil) {
    stub(self) { mock in
      when(mock.nextImages(any(), requests: any())).then { text in
        return Observable.just(1).map { _ in
          throw TestError.error(reason)
        }
      }
    }
  }
}
