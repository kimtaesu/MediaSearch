//
//  LoadMoreView2.swift
//  MediaSearch
//
//  Created by tskim on 28/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

class LoadMoreCell: UICollectionViewCell, NibForNameBySwiftName {
  
  @IBOutlet weak var activitiyIndicator: UIActivityIndicatorView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    activitiyIndicator.do {
      $0.startAnimating()
      $0.color = ColorName.colorAccent
      $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
  }
}
