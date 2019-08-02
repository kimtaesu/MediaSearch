//
//  ImageDownloader.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

class ImageRepository {

  let remoteSource: ImageRemoteSource
  init(remoteSource remote: ImageRemoteSource) {
    self.remoteSource = remote
  }
  func retrieveImage(with url: URL, completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
    assertBackgroundThread()
    self.remoteSource.retrieveImage(with: url, completionHandler: completionHandler)
  }
}
