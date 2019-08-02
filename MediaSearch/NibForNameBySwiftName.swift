//
//  NibForName.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit
protocol NibForNameBySwiftName: SwiftNameIdentifier {
  static var nib: UINib { get }
}
extension NibForNameBySwiftName {
  static var nib: UINib {
    return UINib(nibName: String(describing: Self.self), bundle: nil)
  }
}
