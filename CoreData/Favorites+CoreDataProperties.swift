//
//  Favorites+CoreDataProperties.swift
//  
//
//  Created by tskim on 24/07/2019.
//
//

import Foundation
import CoreData


extension Favorites {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites> {
        return NSFetchRequest<Favorites>(entityName: "Favorites")
    }

    @NSManaged public var o_datetime: NSDate?
    @NSManaged public var o_height: Int32
    @NSManaged public var o_media_type: Int16
    @NSManaged public var o_width: Int32
    @NSManaged public var origin: String?
    @NSManaged public var thumbnail: String?
    @NSManaged public var o_id: String?

}
