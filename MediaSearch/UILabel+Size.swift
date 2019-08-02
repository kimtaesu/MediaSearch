//
//  UILabel+Size.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

extension UILabel {
  func setTextSize(_ size: CGFloat) {
    self.font = self.font.withSize(size)
  }
}

extension UIButton {
  func setTextSize(_ size: CGFloat) {
    self.titleLabel?.setTextSize(size)
  }
}
