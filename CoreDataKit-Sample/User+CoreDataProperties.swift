//
//  User+CoreDataProperties.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/28/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var locations: Set<Location>?

}

// MARK: Generated accessors for locations
extension User {

    @objc(addLocationsObject:)
    @NSManaged public func addToLocations(_ value: Location)

    @objc(removeLocationsObject:)
    @NSManaged public func removeFromLocations(_ value: Location)

    @objc(addLocations:)
    @NSManaged public func addToLocations(_ values: NSSet)

    @objc(removeLocations:)
    @NSManaged public func removeFromLocations(_ values: NSSet)

}
