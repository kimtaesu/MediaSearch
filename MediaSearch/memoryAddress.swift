//
//  memoryAddress.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
///
/// http://stackoverflow.com/a/36539213/226791
///
func addressOf(_ o: UnsafeRawPointer) -> String {
  let addr = Int(bitPattern: o)
  return String(format: "%p", addr)
}

func addressOf<T: AnyObject>(_ o: T) -> String {
  let addr = unsafeBitCast(o, to: Int.self)
  return String(format: "%p", addr)
}
