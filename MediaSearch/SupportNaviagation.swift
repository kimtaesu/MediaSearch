//
//  NavigationViewController.swift
//  MediaSearch
//
//  Created by tskim on 23/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

protocol SupportNaviagation {
  
}
extension SupportNaviagation where Self: UIViewController {
  func dismissViewController(completion: (() -> Void)? = nil) {
    if let navigationController = self.navigationController, navigationController.viewControllers.first != self {
      navigationController.popViewController(animated: true)
    } else {
      self.dismiss(animated: true, completion: completion)
    }
  }
}
