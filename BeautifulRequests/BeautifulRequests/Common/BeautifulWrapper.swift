//
//  AA.swift
//  BeautifulRequests
//
//  Created by tskim on 24/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import UIKit

/// Wrapper for Kingfisher compatible types. This type provides an extension point for
/// connivence methods in Kingfisher.
public struct BeautifulWrapper<Base> {
  public let base: Base
  public init(_ base: Base) {
    self.base = base
  }
}

public protocol BeautifulCompatible: AnyObject { }


extension BeautifulCompatible {
  public var beautiful: BeautifulWrapper<Self> {
    get { return BeautifulWrapper(self) }
    set { }
  }
}

extension UIImageView: BeautifulCompatible { }
