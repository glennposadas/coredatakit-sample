//
//  FormTableViewController.swift
//  CoreDataKit-Sample
//
//  Created by Glenn Posadas on 5/28/17.
//  Copyright © 2017 Citus Labs. All rights reserved.
//

import UIKit

protocol FormTableViewControllerDelegate: NSObjectProtocol {
    func formTableViewController(userDidAddNewData userId: Int, latitude: Double, longitude: Double, timestamp: String)
}

class FormTableViewController: UITableViewController {

    // MARK: - Properties
    
    @IBOutlet weak var textField_UserId: UITextField!
    @IBOutlet weak var textField_Latitude: UITextField!
    @IBOutlet weak var textField_Longitude: UITextField!
    @IBOutlet weak var textField_Timestamp: UITextField!
    
    weak var delegate: FormTableViewControllerDelegate?
    
    // MARK: - Functions
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard let userId = Int(self.textField_UserId.text!),
            let latitude = Double(self.textField_Latitude.text!),
            let longitude = Double(self.textField_Longitude.text!),
            let timestamp = self.textField_Timestamp.text else {
                // TODO: show an alert.
                return
        }
        
        self.delegate?.formTableViewController(
            userDidAddNewData: userId,
            latitude: latitude,
            longitude: longitude,
            timestamp: timestamp
        )
        
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension FormTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        if textField == self.textField_UserId {
            self.textField_Latitude.becomeFirstResponder()
        } else if textField == self.textField_Latitude {
            self.textField_Longitude.becomeFirstResponder()
        } else if textField == self.textField_Longitude {
            self.textField_Timestamp.becomeFirstResponder()
        } else {
            self.save(self)
        }
        
        return true
    }
}
