//
//  LoadMoreView.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class LoadMoreView: UICollectionReusableView, NibForNameBySwiftName {

  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    activityIndicator.do {
      $0.startAnimating()
      $0.color = ColorName.colorAccent
      $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
  }
}
