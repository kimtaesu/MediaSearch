//
//  UIScrollView+Rx.swift
//  MediaSearch
//
//  Created by tskim on 21/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIScrollView {
  var reachedBottom: ControlEvent<Void> {
    let observable = Observable.zip(contentOffset, contentOffset.skip(1)) { (prev: $0, now: $1) }
      .flatMap { [weak base] offsets -> Observable<Void> in
        guard let scrollView = base else {
          return Observable.empty()
        }
        let contentOffset: CGPoint = offsets.now
        let visibleHeight = scrollView.frame.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let scrollY = contentOffset.y + scrollView.contentInset.top
        let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
        let prevContentOffset: CGPoint = offsets.prev
        if prevContentOffset.y > threshold {
          return Observable.empty()
        }
        return scrollY > threshold ? Observable.just(Void()) : Observable.empty()
    }
    return ControlEvent(events: observable)
  }
}
