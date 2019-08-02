//
//  ViewStyle+NavigationBar.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

extension ViewStyle where T: UINavigationBar {
  static var translucent: ViewStyle<T> {
    return ViewStyle<T> { navBar in
      navBar.setBackgroundImage(UIImage(), for: .default)
      navBar.shadowImage = UIImage()
      navBar.isTranslucent = true
      return navBar
    }
  }
}
