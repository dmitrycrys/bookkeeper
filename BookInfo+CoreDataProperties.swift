//
//  BookInfo+CoreDataProperties.swift
//  BookKeeper
//
//  Created by Dmitry Babinsky on 7/18/17.
//  Copyright © 2017 Dmitry Babinsky. All rights reserved.
//

import Foundation
import CoreData


extension BookInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookInfo> {
        return NSFetchRequest<BookInfo>(entityName: "BookInfo")
    }

    @NSManaged public var pageCount: String?
    @NSManaged public var isBookRead: Bool
    @NSManaged public var bookDescription: String?
    @NSManaged public var book: Book?

}
