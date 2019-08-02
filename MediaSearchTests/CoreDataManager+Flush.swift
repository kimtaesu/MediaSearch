//
//  CoreDataManager+Flush.swift
//  MediaSearchTests
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import CoreData
@testable import MediaSearch

extension CoreDataManager {
  func flushData() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
    let objs = try! self.persistentContainer.viewContext.fetch(fetchRequest)
    for case let obj as NSManagedObject in objs {
      self.persistentContainer.viewContext.delete(obj)
    }
    try! self.persistentContainer.viewContext.save()
    
  }
}
