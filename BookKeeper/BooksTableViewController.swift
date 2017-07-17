//
//  BooksTableViewController.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/17/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import UIKit
import CoreData

class BooksTableViewController: UITableViewController {

    var owner: Owner!
    fileprivate var context: NSManagedObjectContext {
        return dataManager.persistenceController.mainManagedObjectContext
    }
    
    override func viewDidLoad() {
        fetchBooks()
    }
    
    func fetchBooks() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error {
            print("fetch error \(error)")
        }
    }
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let predicate = NSPredicate(format: "bookOwner == %@", self.owner)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.context,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.addBook,
            let vc = segue.destination as? AddBookViewController {
            vc.owner = owner
        }
    }
}

// MARK: - UITableViewDataSource

extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let books = fetchedResultsController.fetchedObjects else { return 0 }
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCellId", for: indexPath)
        
        let book = fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = book.title
        cell.detailTextLabel?.text = book.author
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension BooksTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let book = fetchedResultsController.object(at: indexPath)
            dataManager.delete(book: book)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let book = fetchedResultsController.object(at: indexPath)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: StoryboardKeys.addBook)
            as? AddBookViewController else { fatalError() }
        vc.book = book
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension BooksTableViewController: NSFetchedResultsControllerDelegate {
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
