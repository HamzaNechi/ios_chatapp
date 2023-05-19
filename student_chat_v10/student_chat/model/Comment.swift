//
//  Comment.swift
//  student_chat
//
//  Created by Mac Mini 5 on 30/4/2023.
//

import Foundation
class Comment : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs === rhs
    }
    
    let _id: String
    let post:String
    let user:User
    let content: String
}
