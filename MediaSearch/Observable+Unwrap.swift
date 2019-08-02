//
//  PrimitiveSequence+Unwrap.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element == Data {
  func unwrap<T: Decodable>(curPage: Int) -> Observable<T> where T: KakaoResponsable {
    return self.map { data -> T in
      var res = try JSONDecoder().decode(T.self, from: data)
      res.nextPage = curPage + 1
      return res
    }
  }
}
