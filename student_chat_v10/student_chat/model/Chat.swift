//
//  Chat.swift
//  student_chat
//
//  Created by Mac Mini 2 on 6/5/2023.
//

import Foundation
class ChatRoom : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: ChatRoom, rhs: ChatRoom) -> Bool {
        return lhs === rhs
    }
    
    
    let _id: String
    let chat_id: String
    let users: [User]

}
