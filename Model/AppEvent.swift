//
//  Event.swift
//  Activity
//
//  Created by Bahar Atbaş on 28.04.2025.
//

import Foundation

struct AppEvent : Identifiable , Codable{
    
    let id : UUID
    var title : String
    var date : Date
    var catagory : String
    
    init(id: UUID, title: String, date: Date, catagory: String) {
        self.id = id
        self.title = title
        self.date = date
        self.catagory = catagory
    }
}
