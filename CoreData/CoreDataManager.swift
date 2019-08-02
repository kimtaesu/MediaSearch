//
//  CoreDataManager.swift
//  MediaSearch
//
//  Created by tskim on 20/07/2019.
//  Copyright © 2019 hucet. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoreDataManager {
  private let entityName = Favorites.classString()
  private init() { }

  static let shared = CoreDataManager()

  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MediaSearch")
    container.loadPersistentStores(completionHandler: { storeDescription, error in
      if let error = error as NSError? {
        logger.error("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

  func saveContext () {
    let context = CoreDataManager.shared.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        logger.error("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension CoreDataManager {
  func firstFavorite(id: String) -> Favorites? {
    assertBackgroundThread()
    let managedContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
    fetchRequest.predicate = NSPredicate(format: "o_id == %@", id)
    fetchRequest.fetchLimit = 1

    var favorites: [NSManagedObject] = []

    do {
      favorites = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      logger.info("Could not fetch. \(error), \(error.userInfo)")
    }

    return favorites.first as? Favorites
  }

  func delete(favorite: Favorites) {
    let managedContext = persistentContainer.viewContext

    do {
      managedContext.delete(favorite)
      try managedContext.save()
    } catch let error as NSError {
      logger.info("Could not delete. \(error), \(error.userInfo)")
    }
  }

  @discardableResult
  func insertFavorite(_ thumbnail: Thumbnailable) -> Favorites? {
    assertBackgroundThread()
    if let stored = self.firstFavorite(id: thumbnail.id) {
      return stored
    }
    let managedContext = persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!

    let favorite = Favorites(entity: entity, insertInto: managedContext)
    favorite.setValuesForKeys(
      [
        "o_id": thumbnail.id,
        "o_media_type": thumbnail.media_type.rawValue,
        "o_datetime": thumbnail.datetime,
        "o_height": thumbnail.height,
        "o_width": thumbnail.width,
        "origin": thumbnail.origin_url,
        "thumbnail": thumbnail.thumbnail_url
      ]
    )
    do {
      try managedContext.save()
      return favorite
    } catch let error as NSError {
      logger.info("Could not save. \(error), \(error.userInfo)")
      return nil
    }
  }

  func fetchFavorites() -> [Thumbnailable] {
    assertBackgroundThread()
    let managedContext = persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

    do {
      let favorites = try managedContext.fetch(fetchRequest)
      return favorites as? [Thumbnailable] ?? []
    } catch let error as NSError {
      logger.info("Could not fetch. \(error), \(error.userInfo)")
      return []
    }
  }
}
