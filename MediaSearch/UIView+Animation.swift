//
//  View+Animation.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  func fadeIn(delay: TimeInterval = 0, duration: TimeInterval = 0.3) {
    if self.alpha >= 1 { return }
    UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
      self.alpha = 1.0
    })
  }
  
  func fadeOut(delay: TimeInterval = 0, duration: TimeInterval = 0.3) {
    if self.alpha <= 0 { return }
    UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn], animations: {
      self.alpha = 0.0
    })
  }
}
