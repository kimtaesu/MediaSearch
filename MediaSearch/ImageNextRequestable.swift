//
//  ImageReqeusts.swift
//  MediaSearch
//
//  Created by tskim on 22/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import RxSwift

protocol ImageNextRequestable {
  associatedtype Res where Res: KakaoResponsable
  
  func request(session: URLSession, urlReqeust: URLRequest, search: SearchOption) -> Observable<Res>
}

struct KakaoImageRequest: ImageNextRequestable {
  func request(session: URLSession, urlReqeust: URLRequest, search: SearchOption) -> Observable<KakaoImageResponse> {
    return session.rx.data(request: urlReqeust)
      .unwrap(curPage: search.page)
      .catchError({ error in
        logger.error("http request error: \(error)")
        return Observable.just(KakaoImageResponse(meta: Meta.fallback(nextPage: search.page), documents: []))
      })
  }
}

struct KakaoVClipRequest: ImageNextRequestable {
  func request(session: URLSession, urlReqeust: URLRequest, search: SearchOption) -> Observable<KakaoVClipResponse> {
    return session.rx.data(request: urlReqeust)
      .unwrap(curPage: search.page)
      .catchError({ error in
        logger.error("http request error: \(error)")
        return Observable.just(KakaoVClipResponse(meta: Meta.fallback(nextPage: search.page), documents: []))
      })
  }
}
