//
//  Users+CoreDataProperties.swift
//  Activity
//
//  Created by Bahar Atbaş on 24.06.2025.
//
//

import Foundation
import CoreData


extension UsersEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UsersEntity> {
        return NSFetchRequest<UsersEntity>(entityName: "Users")
    }

    @NSManaged public var confirmPassword: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}

extension UsersEntity : Identifiable {

}
