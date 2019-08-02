//
//  Logger.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import SwiftyBeaver
import UIKit

let logger: SwiftyBeaver.Type = {
  let console = ConsoleDestination()
  let file = FileDestination()
  console.format = "$DHH:mm:ss$d $L $N $F :$l [$T] $M"
  $0.addDestination(console)
  $0.addDestination(file)
  return $0
}(SwiftyBeaver.self)
