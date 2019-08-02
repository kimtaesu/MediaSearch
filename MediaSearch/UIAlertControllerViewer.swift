//
//  UIAlertControllerViewer.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

class UIAlertControllerViewer {
  private static var _instance: UIAlertControllerViewer = {
    return UIAlertControllerViewer()
  }()
  static var shared: UIAlertControllerViewer {
    return _instance
  }
}

extension UIAlertControllerViewer {
  func show(_ vc: UIViewController, alert: UIAlertPlainViewModel) {
    let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style ?? .alert)
    if let ok = alert.ok?.toUIAlertAcion {
      alertController.addAction(ok)
    }
    if let cancel = alert.cancel?.toUIAlertAcion {
      alertController.addAction(cancel)
    }
    vc.present(alertController, animated: true)
  }
  
}
