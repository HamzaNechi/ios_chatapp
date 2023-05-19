//
//  Like.swift
//  student_chat
//
//  Created by Mac Mini 5 on 30/4/2023.
//

import Foundation

class Like : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Like, rhs: Like) -> Bool {
        return lhs === rhs
    }
    
    
    let post:String
    let user:String
}
