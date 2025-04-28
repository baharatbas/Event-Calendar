//
//  Event.swift
//  Activity
//
//  Created by Bahar Atbaş on 28.04.2025.
//

import Foundation
enum EventCatagory : String, Codable, CaseIterable {
    
    case work = "İş"
    case personel = "Kişisel"
    case holiday = "Tatil"
}
struct Event : Identifiable , Codable{
    
    let id : UUID
    var title : String
    var date : Date
    var location : String
    var description : String
    var catagory : String
    
    init(id: UUID, title: String, date: Date, location: String, description: String, catagory: String) {
        self.id = id
        self.title = title
        self.date = date
        self.location = location
        self.description = description
        self.catagory = catagory
    }
}
