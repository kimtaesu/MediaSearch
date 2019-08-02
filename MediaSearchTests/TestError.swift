//
//  TestError.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

enum TestError: Error, LocalizedError {
  case error(String?)
  
  var failureReason: String? {
    switch self {
    case .error(let reason):
      return reason
    }
  }
}
