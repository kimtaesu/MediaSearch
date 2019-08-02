//
//  UIAlertActionModel.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit
import UIKit

struct UIAlertActionModel {
  let title: String
  let style: UIAlertAction.Style
  let action: ((UIAlertAction) -> Void)?
  
  public init(title: String, style: UIAlertAction.Style = UIAlertAction.Style.default, action: ((UIAlertAction) -> Void)? = nil) {
    self.title = title
    self.style = style
    self.action = action
  }
}

extension UIAlertActionModel {
  var toUIAlertAcion: UIAlertAction {
    return UIAlertAction(title: self.title, style: self.style, handler: self.action)
  }
}
