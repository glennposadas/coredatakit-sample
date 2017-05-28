//
//  Location+CoreDataProperties.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/28/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var timestamp: String?

}
