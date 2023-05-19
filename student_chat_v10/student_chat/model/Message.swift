//
//  Message.swift
//  student_chat
//
//  Created by Mac Mini 2 on 6/5/2023.
//

import Foundation
class MessageRoom : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: MessageRoom, rhs: MessageRoom) -> Bool {
        return lhs === rhs
    }
    
    
    let _id: String
    let chat_id: String
    let user_id: User
    let content: String
    let date : String
}
