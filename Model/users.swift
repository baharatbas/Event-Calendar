//
//  users.swift
//  Activity
//
//  Created by Bahar Atbaş on 24.06.2025.
//

import Foundation

    struct users : Identifiable , Codable {
        
        let id : UUID
        var name : String
        var username : String
        var password : String
        var confirmPassword : String
        
        init(id: UUID, name: String, username: String , password: String, confirmPassword: String ) {
            self.id = id
            self.name = name
            self.username = username
            self.password = password
            self.confirmPassword = confirmPassword
        }
}
