//
//  KakaoService2.swift
//  MediaSearch
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import BeautifulRequests
import RxSwift

class KakaoService: KakaoServiceType {

  let urlSession: URLSession
  let scheduler: RxSchedulerType
  var urlComponent = URLComponents(string: Enviroment.KAKAO_BASE_URL)

  init(urlSession: URLSession, scheduler: RxSchedulerType) {
    self.urlSession = urlSession
    self.scheduler = scheduler
  }

  func nextImages(_ keyword: String, requests: [(request: ImageRequest, searchOption: SearchOption)]) -> Observable<[GenericPageThumbnail]> {
    let concreateRequest = requests.compactMap { item -> Observable<GenericPageThumbnail> in
      assertBackgroundThread()
      let (request, searchOption) = item
      switch request {
      case .image(let req):
        urlComponent?.path = Enviroment.IMAGE_SEACH_PATH
        guard let urlRequest = try? self.makeKakaoHTTPURLRequest(urlCompoennt: urlComponent!, searchOption: searchOption) else { return .empty() }
        return req.request(session: urlSession, urlReqeust: urlRequest, search: searchOption)
          .map {
            logger.verbose("current thread name: \(threadName())")
            return $0.toGenericThumbnail(request: request)
        }
      case .vclip(let req):
        urlComponent?.path = Enviroment.VCLIP_SEACH_PATH
        guard let urlRequest = try? self.makeKakaoHTTPURLRequest(urlCompoennt: urlComponent!, searchOption: searchOption) else { return .empty() }
        return req.request(session: urlSession, urlReqeust: urlRequest, search: searchOption)
          .map { t -> GenericPageThumbnail in
            logger.verbose("current thread name: \(threadName())")
            return t.toGenericThumbnail(request: request)
        }
      }
    }
    return Observable.zip(concreateRequest).delay(0.3, scheduler: self.scheduler.io)
  }

  private func makeKakaoHTTPURLRequest(urlCompoennt: URLComponents?, searchOption: SearchOption) throws -> URLRequest {
    guard let urlparameters = try? searchOption.tryAsDictionary() else {
      throw AppError.decodeURLParam
    }
    urlComponent?.queryItems = urlparameters.map {
      URLQueryItem(name: $0.key, value: $0.value as? String ?? String(describing: $0.value))
    }
    
    guard let url = urlComponent?.url else {
        throw AppError.resolveURL
    }
      var urlRequest = URLRequest(url: url)
      urlRequest.addValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
      urlRequest.addValue("KakaoAK \(Enviroment.API_KEY)", forHTTPHeaderField: "Authorization")
      urlRequest.httpMethod = HTTPMethod.get.rawValue
      return urlRequest
  }
}
