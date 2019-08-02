//
//  UIViewController+Alert.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import NotificationView
import RxCocoa
import RxSwift

extension Reactive where Base: UIViewController {
  var showAlertView: Binder<UIAlertPlainViewModel> {
    return Binder(self.base) { vc, alert in
      UIAlertControllerViewer.shared.show(vc, alert: alert)
    }
  }
}

extension Reactive where Base: UIViewController {
  var showNotification: Binder<NotificationModel> {
    return Binder(self.base) { vc, notification in
      let notificationView = notification.notificationView
      notificationView.show()
    }
  }
}

extension Reactive where Base: UIViewController, Base: NotificationDelegatable {
  var showNotificationWithDelegate: Binder<NotificationModel> {
    return Binder(self.base) { vc, notification in
      let notificationView = notification.notificationView
      notificationView.delegate = vc
      notificationView.show()
    }
  }
}

extension Reactive where Base: UIViewController, Base: UserProgressView {
  var showProgress: Binder<Bool> {
    return Binder(self.base) { vc, isShow in
      if isShow {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        UIApplication.shared.beginIgnoringInteractionEvents()
        vc.activityIndicator.fadeIn()
        vc.activityIndicator.startAnimating()
      } else {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        UIApplication.shared.endIgnoringInteractionEvents()
        vc.activityIndicator.stopAnimating()
        vc.activityIndicator.fadeOut()
      }
    }
  }
}
