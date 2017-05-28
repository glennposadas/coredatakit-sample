//
//  CoreDataService.swift
//  GeoDrive
//
//  Created by Glenn Posadas on 5/26/17.
//  Copyright © 2017 Glenn Posadas. All rights reserved.
//

import CoreData
import CoreLocation
import UIKit

class CoreDataService {
    
    typealias LocationsFetchServiceCallBack = (_ locations: [Location]?) -> Void
    typealias UsersFetchCallBack = (_ users: [User]?) -> Void
    typealias DeleteLocationCallBack = (_ success: Bool?) -> Void
    
    public func delete(locationFromLocalDB userId: Int, location: Location, withBlock completion: @escaping DeleteLocationCallBack) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        self.findUser(withUserId: userId) { (usersFound) in
            
            guard let usersFound = usersFound,
                let user = usersFound.first else {
                    completion(false)
                    return
            }
            
            user.locations?.remove(location)
            appDelegate.coreDataHelper.backgroundContext?.delete(location)
            
            if user.locations?.count == 0 {
                appDelegate.coreDataHelper.backgroundContext?.delete(user)
            }
            
            appDelegate.coreDataHelper.saveContext()
            completion(true)
        }
    }
    
    public func fetchUsers(withBlock completion: @escaping UsersFetchCallBack) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        var fetchedUsers = [User]()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            fetchedUsers = try appDelegate.coreDataHelper.backgroundContext?.fetch(fetchRequest) as! [User]
        } catch let nserror1 as NSError {
            print("CoreDataService: An error has occured: \(nserror1.localizedDescription)")
            completion(nil)
            return
        }
        
        completion(fetchedUsers)
    }
    
    public func fetchLocations(ofUser userId: Int, withBlock completion: @escaping LocationsFetchServiceCallBack) {
        self.findUser(withUserId: userId) { (usersFound) in
            if let user = usersFound?.first,
                let locations = user.locations {
                completion(locations.map { $0 })
                return
            }
            
            completion(nil)
        }
    }
    
    private func findUser(withUserId userId: Int, withBlock completion: @escaping UsersFetchCallBack) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "userId == \(userId)")
        
        var usersFound = [User]()
        
        do {
            usersFound = try appDelegate.coreDataHelper.backgroundContext?.fetch(fetchRequest) as! [User]
        } catch let nserror1 as NSError {
            print("CoreDataService: An error has occured: \(nserror1.localizedDescription)")
            return
        }
        
        completion(usersFound)
    }
    
    public func save(userId: Int, latitude: CLLocationDegrees, longitude: CLLocationDegrees, timestamp: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let context = appDelegate.coreDataHelper.backgroundContext else { return }
        
        let newLocation = NSEntityDescription.insertNewObject(
            forEntityName: "Location",
            into: context
            ) as! Location
        newLocation.latitude = latitude
        newLocation.longitude = longitude
        newLocation.timestamp = timestamp
        
        self.findUser(withUserId: userId) { (usersFound) in
            
            guard let usersFound = usersFound else { return }
            
            if let user = usersFound.first {
                user.locations?.insert(newLocation)
                appDelegate.coreDataHelper.saveContext()
                return
            }
            
            // Add only if user is non existent
            if usersFound.count == 0 {
                let user = NSEntityDescription.insertNewObject(
                    forEntityName: "User",
                    into: appDelegate.coreDataHelper.backgroundContext!) as! User
                user.userId = Int16(userId)
                user.locations?.insert(newLocation)
                appDelegate.coreDataHelper.saveContext()
            }
        }
    }
}
