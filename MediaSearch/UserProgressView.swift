//
//  NetworkProgressable.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import UIKit

protocol UserProgressView: class, AssociatedObjectStore {
  var activityIndicator: UIActivityIndicatorView { get set }
}

private var activityIndicatorKey = "activityIndicatorKey"

extension UserProgressView where Self: UIViewController {
  var activityIndicator: UIActivityIndicatorView {
    get {
      let activityIndicator = self.associatedObject(forKey: &activityIndicatorKey, default: UIActivityIndicatorView())

      if activityIndicator.superview == nil {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.style = .white
        activityIndicator.color = ColorName.colorAccent
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.alpha = 0
        self.view.addSubview(activityIndicator)
      }
      return activityIndicator
    }
    set {
      fatalError("Not Implements")
//      self.setAssociatedObject(newValue, forKey: &activityIndicatorKey)
//      logger.info("setAssociatedObject \(newValue)")
    }
  }
}
