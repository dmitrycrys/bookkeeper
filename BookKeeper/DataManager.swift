//
//  DataManager.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/18/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import Foundation
import UIKit
import CoreData

let dataManager = DataManager.sharedInstance

class DataManager: NSObject {
    
    private let ownerEntityName = "Owner"
    private let bookEntityName = "Book"
    private let bookInfoEntityName = "BookInfo"
    
    static let sharedInstance = DataManager()
    private override init() {}
    var persistenceController: PersistenceController!
    private var context: NSManagedObjectContext {
        return persistenceController.mainManagedObjectContext
    }
    
    private var ownerEntity: NSEntityDescription {
        guard let owner = NSEntityDescription.entity(forEntityName: ownerEntityName, in: context) else { fatalError() }
        return owner
    }
    
    private var bookEntity: NSEntityDescription {
        guard let book = NSEntityDescription.entity(forEntityName: bookEntityName, in: context) else { fatalError() }
        return book
    }
    
    private var bookInfo: NSEntityDescription {
        guard let info = NSEntityDescription.entity(forEntityName: bookInfoEntityName, in: context) else {
            fatalError()
        }
        return info
    }
    
    /**
     Save owner with Core Data
     - parameter name: Book owner name
     */
    func addOwner(name: String) {
        let owner = Owner(entity: ownerEntity, insertInto: context)
        owner.name = name
        persistenceController.save()
    }
    
    /**
     Save book with Core Data
     - parameter owner: pass owner for whome book should add
     - parameter title: book title
     - parameter author: book author
     - parameter image: book cover image
     */
    func addBook(owner: Owner, title: String, author: String,
                 image: UIImage, pageCount: String, description: String, isRead: Bool) {
        guard let imageData = UIImagePNGRepresentation(image) else { fatalError() }
        let book = Book(entity: bookEntity, insertInto: context)
        book.title = title
        book.author = author
        book.image = imageData as NSData
        book.bookOwner = owner
        
        let info = BookInfo(entity: bookInfo, insertInto: context)
        info.isBookRead = isRead
        info.pageCount = pageCount
        info.bookDescription = description
        
        book.bookInfo = info
        
        persistenceController.save()
    }
    
    func delete(owner: Owner) {
        context.delete(owner)
        persistenceController.save()
    }
    
    func delete(book: Book) {
        context.delete(book)
        persistenceController.save()
    }
}
