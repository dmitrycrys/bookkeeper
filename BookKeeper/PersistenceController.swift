//
//  PersistenceController.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/17/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import Foundation
import CoreData

class PersistenceController {
    
    private let fileName = "BookKeeper"
    typealias InitCallbackBlock = (_ isSuccess: Bool, _ error: Error?) -> Void
    private (set) var mainManagedObjectContext: NSManagedObjectContext!
    private var privateManagedObjectContext: NSManagedObjectContext!
    
    init(completion: @escaping InitCallbackBlock) {        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "momd") else {
            fatalError("Cant find url resource")
        }
        
        guard let mom = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Cant init managed object model")
        }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        mainManagedObjectContext.parent = privateManagedObjectContext
        
        DispatchQueue.global(qos: .background).async {
            let psc = self.privateManagedObjectContext.persistentStoreCoordinator
            let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                           NSInferMappingModelAutomaticallyOption: true]
            
            let fileManager = FileManager.default
            guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("cat find documentsUrl")
            }
            
            let storeURL = documentsUrl.appendingPathComponent(self.fileName).appendingPathExtension("sqlite")
            
            do {
                try psc?.addPersistentStore(ofType: NSSQLiteStoreType,
                                            configurationName: nil,
                                            at: storeURL,
                                            options: options)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch let error {
                print("error = \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    func save() {
        if !privateManagedObjectContext.hasChanges && !mainManagedObjectContext.hasChanges { return }
        
        mainManagedObjectContext.performAndWait {
            do {
                try self.mainManagedObjectContext.save()
            } catch let error {
                print("error \(error)")
            }
            
            self.privateManagedObjectContext.perform({
                do {
                    try self.privateManagedObjectContext.save()
                } catch let error {
                    print("error = \(error)")
                }
            })
        }
    }
}
