//
//  UICollectionView+Rx.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UICollectionView {
  /*
   setContentOffset 을 지정하고 있으므로 조심햐서 다뤄야 합니다.
   다른 곳에서 setContentOffset 을 사용하고 있으면 사용해서는 안됩니다.
 */
  var refreshControl: Binder<Bool> {
    return Binder(self.base) { cv, isRefresh in
      guard let refreshControl = cv.refreshControl else { return }
      if isRefresh {
        let padding: CGFloat = 20
        cv.setContentOffset(CGPoint(x: 0, y: -refreshControl.frame.height - padding), animated: true)
        refreshControl.beginRefreshing()
      } else {
        cv.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        refreshControl.endRefreshing()
      }
    }
  }
}
