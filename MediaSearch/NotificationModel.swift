//
//  NotificationModel.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import NotificationView
import UIKit

struct NotificationModel {
  let title: String?
  let subtitle: String?
  let body: String?
  let image: UIImage?
  let imageTintColor: UIColor?

  public init(
    title: String? = nil,
    subtitle: String? = nil,
    body: String? = nil,
    image: UIImage? = nil,
    imageTintColor: UIColor? = nil) {
    self.title = title
    self.subtitle = subtitle
    self.body = body
    self.image = image
    self.imageTintColor = imageTintColor
  }
}

extension NotificationModel {
  var notificationView: NotificationView {
    let notificationView = NotificationView.default
      .then {
        $0.title = self.title
        $0.subtitle = self.subtitle
        $0.body = self.body
        $0.image = self.image
        $0.imageView.tintColor = self.imageTintColor
        $0.hideDuration = 1
    }
    return notificationView
  }
}
