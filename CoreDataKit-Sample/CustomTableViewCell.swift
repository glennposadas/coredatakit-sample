//
//  CustomTableViewCell.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/27/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet private weak var label_Latitude: UILabel!
    @IBOutlet private weak var label_Longitude: UILabel!
    @IBOutlet private weak var label_Timestamp: UILabel!
    
    var location: Location? {
        didSet {
            guard let location = self.location else { return }
            self.label_Latitude.text = "\(location.latitude)"
            self.label_Longitude.text = "\(location.longitude)"
            self.label_Timestamp.text = location.timestamp
        }
    }
}
