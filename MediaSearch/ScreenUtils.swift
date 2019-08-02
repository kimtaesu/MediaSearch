//
//  ScreenUtils.swift
//  MediaSearch
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

struct ScreenUtils {
  private struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let maxLength = max(ScreenSize.width, ScreenSize.height)
    static let minLength = min(ScreenSize.width, ScreenSize.height)
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
  }

  static var isIPhoneXOver: Bool = {
    return UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxLength >= 812.0
  }()
}
