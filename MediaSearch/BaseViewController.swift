//
//  BaseViewController.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//
import DeallocationChecker
import RxSwift
import UIKit

class BaseViewController: UIViewController, SwiftNameIdentifier, HasDisposeBag {
  
  lazy private(set) var className: String = {
    return type(of: self).description().components(separatedBy: ".").last ?? ""
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required convenience init?(coder aDecoder: NSCoder) {
    self.init()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    #if DEBUG
    DeallocationChecker.shared.checkDeallocation(of: self)
    #endif
  }
  
  deinit {
    logger.info("deinit: \(self.className)")
  }
}
