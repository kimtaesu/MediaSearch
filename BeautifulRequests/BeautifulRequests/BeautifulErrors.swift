//
//  AA.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

public enum BeautifulErrors: Error {
  case unrecognizableSource
  case unknwon
  case nonHTTPResponse(URLResponse?)
  case noImage(Data?)
  case httpRequestFailed(HTTPURLResponse)
}
