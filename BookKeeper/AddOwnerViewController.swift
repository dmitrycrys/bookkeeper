//
//  AddOwnerViewController.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/17/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import UIKit

class AddOwnerViewController: UIViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var ownerNameTextField: UITextField!
    var persistenceController: PersistenceController!
    
    var ownerName: String {
        return ownerNameTextField.text ?? ""
    }
    
    @IBAction func saveOwnerActionButton(_ sender: UIBarButtonItem) {
        dataManager.addOwner(name: ownerName)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func changeTextInTextField(_ sender: UITextField) {
        let isEmpty = sender.text == ""
        let isSpaceOnly = sender.text == " "
        saveBarButton.isEnabled = isEmpty || isSpaceOnly ? false : true
    }
}
