//
//  AppDelegate.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/27/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: Core Data Properties
    
    lazy var coreDataStore: CoreDataStore = {
        let coreDataStore = CoreDataStore()
        return coreDataStore
    }()
    
    lazy var coreDataHelper: CoreDataHelper = {
        let coreDataHelper = CoreDataHelper()
        return coreDataHelper
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.coreDataHelper.saveContext()
    }
}

