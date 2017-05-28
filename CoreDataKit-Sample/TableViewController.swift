//
//  TableViewController.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/28/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    // MARK: - Properties
    
    var users = [User]()
    
    // MARK: - Functions
    
    func fetchData() {
        let coreDataService = CoreDataService()
        coreDataService.fetchUsers { [weak self] (users) in
            guard let strongSelf = self,
                let users = users else { return }
            strongSelf.users = users
            strongSelf.tableView.reloadData()
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Present New Data" {
            if let navCon = segue.destination as? UINavigationController {
                if let formTVC = navCon.viewControllers.first as? FormTableViewController {
                    formTVC.delegate = self
                }
            }
        }
    }
}

// MARK: - FormTableViewControllerDelegate

extension TableViewController: FormTableViewControllerDelegate {
    func formTableViewController(userDidAddNewData userId: Int, latitude: Double, longitude: Double, timestamp: String) {
        let coreDataService = CoreDataService()
        coreDataService.save(
            userId: userId,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp
        )
    }
}

// MARK: - UITableViewController Delegates

extension TableViewController {
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            let row = index.row
            let section = index.section
            
            let user = self.users[section]
            let locationsArray = user.locations!.map { $0 }
            let location = locationsArray[row]
            
            let coreDataService = CoreDataService()
            coreDataService.delete(
                locationFromLocalDB: Int(user.userId),
                location: location,
                withBlock: { [weak self] (didSucceed) in
                    
                    print("Delete succeeded? --> \(String(describing: didSucceed))")
                    guard let strongSelf = self else { return }
                    if didSucceed! {
                        strongSelf.users[section].locations?.remove(location)
                        strongSelf.tableView.reloadData()
                    }
            })
        }
        
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116.0
    }
}

// MARK: - UITableViewController Data Source

extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        // convert the Set<Location> to Array by mapping.
        
        let user = self.users[section]
        let locations = user.locations!
        let locationsArray = locations.map { $0 }
        let location = locationsArray[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.location = location
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users[section].locations!.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let user = self.users[section]
        return "USER ID -- \(user.userId)"
    }
}
