//
//  Encodable+Dictionary.swift
//  MediaSearch
//
//  Created by tskim on 19/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation

extension Encodable {
  func tryAsDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
