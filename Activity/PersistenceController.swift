//
//  PersistenceController.swift
//  Activity
//
//  Created by Bahar Atbaş on 11.05.2025.
//

import Foundation
import CoreData

//Core data işlemi için kullanılan presistence Controller
//verileri disk üzerinde kalıcı veya geçici olarak depolama yapar
struct PersistenceController{
    
    //uygulama boyunca tek bir presistence kullanılır.  shared ile erişim sağlanır.
    static let shared = PersistenceController()
    //NSPersistentContainer core data nın kalbidir , veritabanını yükler ve işlemleri yönetir.
    let container: NSPersistentContainer
    
    
    //veriler bellekte kalıcı olarak tutulut eğer true yapsaydık geçici olarak hafızada tutulurdu.
    init(inMemory: Bool = false) {
        
        //oluşturduğumuz  .xdatamodel i alırız container a aktarırız
            container = NSPersistentContainer(name: "ActivityModel") // Veri modelinizin adı
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
