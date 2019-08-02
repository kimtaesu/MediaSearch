//
//  PaddingLabel.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

@IBDesignable
public class PaddingLabel: UILabel {

  @IBInspectable public var topInset: CGFloat = 5.0
  @IBInspectable public var bottomInset: CGFloat = 5.0
  @IBInspectable public var leftInset: CGFloat = 7.0
  @IBInspectable public var rightInset: CGFloat = 7.0

  override public func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
    super.drawText(in: rect.inset(by: insets))
  }

  override public var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + leftInset + rightInset,
      height: size.height + topInset + bottomInset
    )
  }
}
