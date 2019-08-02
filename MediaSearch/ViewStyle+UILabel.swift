//
//  ViewStyle+UILabel.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

extension ViewStyle where T: UILabel {
  static var empty: ViewStyle<T> {
    return ViewStyle<T> { label in
      label.textColor = ColorName.emptyLabel
      label.setTextSize(18)
      label.textAlignment = .center
      return label
    }
  }
}
