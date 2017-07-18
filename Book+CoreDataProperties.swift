//
//  Book+CoreDataProperties.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/18/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var author: String?
    @NSManaged public var image: NSData?
    @NSManaged public var title: String?
    @NSManaged public var bookOwner: Owner?
    @NSManaged public var bookInfo: BookInfo?

}
