//
//  Test+Equal.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
@testable import MediaSearch

extension Thumbnailable {
  public static func == (lhs: Thumbnailable, rhs: Thumbnailable?) -> Bool {
    return lhs.identity == rhs?.identity
  }
}
extension Favorites: Equatable {
  public static func == (lhs: Favorites, rhs: Thumbnailable?) -> Bool {
    return lhs.identity == rhs?.identity
  }
}

extension KakaoImage: Equatable {
  public static func == (lhs: KakaoImage, rhs: Thumbnailable?) -> Bool {
    return lhs.identity == rhs?.identity
  }
}

extension UIAlertPlainViewModel: Equatable {
  public static func == (lhs: UIAlertPlainViewModel, rhs: UIAlertPlainViewModel) -> Bool {
    return lhs.title == rhs.title &&
      lhs.message == rhs.message &&
      lhs.style == rhs.style &&
      lhs.ok == rhs.ok &&
      lhs.cancel == rhs.cancel
  }
}

extension UIAlertActionModel: Equatable {
  public static func == (lhs: UIAlertActionModel, rhs: UIAlertActionModel) -> Bool {
    return lhs.title == rhs.title && lhs.style == rhs.style
  }
}
