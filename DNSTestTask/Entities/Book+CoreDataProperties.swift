//
//  Book+CoreDataProperties.swift
//  DNSTestTask
//
//  Created by Иван Суслов on 17.05.2024.
//
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var title: String?
    @NSManaged public var author: String?
    @NSManaged public var year: Int16

}

extension Book : Identifiable {

}
