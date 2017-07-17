//
//  OwnerTableViewController.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/17/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import UIKit
import CoreData

class OwnerTableViewController: UITableViewController {

    var owners: [Owner] = []
    var persistenceController: PersistenceController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        fetchFromCoreData()
    }
    
    func fetchFromCoreData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Owner")
        do {
            guard let result = try persistenceController.mainManagedObjectContext.fetch(fetchRequest) as? [Owner] else {
                fatalError("fatal")
            }
            owners = result
            tableView.reloadData()
        } catch let error {
            print(" fetch error = \(error)")
        }
    }
    
    @IBAction func fetchActionButton(_ sender: UIBarButtonItem) {
        self.fetchFromCoreData()
    }
    
    @IBAction func addOwnerButtonAction(_ sender: UIBarButtonItem) {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Owner",
                                                           in: persistenceController.mainManagedObjectContext)
        let entity = Owner(entity: entityDescription!, insertInto: persistenceController.mainManagedObjectContext)
        entity.name = "abc"
        persistenceController.save()
        
        fetchFromCoreData()
    }
}

// MARK: - UITableViewDataSource
extension OwnerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCellId", for: indexPath)
        
        cell.textLabel?.text = owners[indexPath.row].name
        
        return cell
    }
}
