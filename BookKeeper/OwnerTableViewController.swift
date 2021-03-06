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

    fileprivate var context: NSManagedObjectContext {
        return dataManager.persistenceController.mainManagedObjectContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchOwners()
    }
    
    func fetchOwners() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("fetch error \(error)")
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Owner> = {
        let fetchRequest = NSFetchRequest<Owner>(entityName: "Owner")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
}

// MARK: - UITableViewDataSource
extension OwnerTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let owners = fetchedResultsController.fetchedObjects else { return 0 }
        return owners.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ownerCellId", for: indexPath)
        
        let owner = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = owner.name
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension OwnerTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let owner = fetchedResultsController.object(at: indexPath)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: StoryboardKeys.booksVC)
            as? BooksTableViewController else { fatalError() }
        vc.owner = owner
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let owner = fetchedResultsController.object(at: indexPath)
            dataManager.delete(owner: owner)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}

extension OwnerTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any,
                    at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
}
