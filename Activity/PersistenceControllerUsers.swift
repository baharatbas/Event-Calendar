//
//  PersistenceControllerUsers.swift
//  Activity
//
//  Created by Bahar Atbaş on 24.06.2025.
//

import Foundation
import CoreData

struct PersistenceControllerUsers{
    static let shard = PersistenceControllerUsers()
    let container : NSPersistentContainer
    
    init(inMemory : Bool = false){
        container = NSPersistentContainer(name: "UsersModel") // Veri modelinizin adı
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
    //veritabanına bağlanmaya çalışıyoruz.
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Core Data yüklenemedi: \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    }

