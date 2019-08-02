//
//  UIImageView+ Beautiful.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

extension BeautifulWrapper where Base: UIImageView {
  public func setImage(with url: URL?) {
    if let localUrl = url {
      BeautifulRequests.shared.retrieveImage(with: localUrl, completionHandler: { result in
        DispatchQueue.main.async {
          assertMainThread()
          switch result {
          case .success(let image):
            self.base.image = image
            print("successed to download \(url)")
            break
          case .failure(let error):
            print("failed to download: \(error)")
            break
          }
        }
      })
    }
  }
}
