//
//  AA.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class BeautifulRequests {
  static let shared = BeautifulRequests()

  private let repository: ImageRepository
  private let remoteSource: ImageRemoteSource
  let workQueue = DispatchQueue(
    label: "com.hucet.BeautifulRequests.downloadImage.\(UUID().uuidString)",
    qos: .utility,
    attributes: .concurrent
  )
  
  init() {
    remoteSource = ImageRemoteSource()
    repository = ImageRepository(remoteSource: remoteSource)
  }

  func retrieveImage(with url: URL, completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
    workQueue.async(execute: { [weak repository] in
      // 메모리 캐시에 존재하면 메모리 캐시로 부터 가져온다.
      
      // 디스크 캐시에 존재하면 디스크 캐시로 부터 가져온다.
      
      // 캐시에 없다면 원본 소스로 부터 가져온다.
      repository?.retrieveImage(with: url, completionHandler: completionHandler)
    })
  }
}
