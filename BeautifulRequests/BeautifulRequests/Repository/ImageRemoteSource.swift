//
//  ImageRemote.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

class ImageRemoteSource {
  open var timeoutInterval = 5.0
  private var session: URLSession
  open weak var sessionDelegate: URLSessionDelegate?
  
  init() {
    session = URLSession(
      configuration: sessionConfiguration,
      delegate: URLSessionDelegate(),
      delegateQueue: .none
    )
  }
  deinit {
    // 모든 미해결 된 작업을 취소 한 다음 세션을 무효화합니다.
    session.invalidateAndCancel()
  }
  // 캐시, 쿠키 또는 자격 증명에 영구 저장소를 사용하지 않는 세션 구성입니다.
  open var sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.ephemeral {
    didSet {
      session.invalidateAndCancel()
      session = URLSession(configuration: sessionConfiguration, delegate: sessionDelegate, delegateQueue: nil)
    }
  }
  
  func retrieveImage(with url: URL, completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
    //  URL로드는 원본 소스에서만로드해야합니다.
    // .reloadIgnoringLocalCacheData
    let urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeoutInterval)
    
    defer { HTTPLog.log(request: urlRequest) }
    
    let downloadTask = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
      guard let response = response, let data = data else {
        completionHandler?(.failure(BeautifulErrors.unknwon))
        return
      }
      guard let httpResponse = response as? HTTPURLResponse else {
        completionHandler?(.failure(BeautifulErrors.nonHTTPResponse(response)))
        return
      }
      defer { HTTPLog.log(data: data, response: httpResponse, error: error) }
      if 200 ..< 300 ~= httpResponse.statusCode {
        if let image = UIImage(data: data) {
          completionHandler?(.success(image))
        } else {
          completionHandler?(.failure(BeautifulErrors.noImage(data)))
        }
        return
      } else {
        completionHandler?(.failure(BeautifulErrors.httpRequestFailed(httpResponse)))
        return
      }
    })
    downloadTask.resume()
  }
}

class URLSessionDelegate: NSObject, URLSessionDataDelegate {}
