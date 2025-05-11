//
//  Event+CoreDataProperties.swift
//  Activity
//
//  Created by Bahar Atbaş on 11.05.2025.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var catagory: String?
    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var title: String?

}

extension Event : Identifiable {

}
