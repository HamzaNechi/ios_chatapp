//
//  ChatMessage.swift
//  student_chat
//
//  Created by Mac Mini 2 on 8/5/2023.
//

import Foundation
class ChatMessage : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        return lhs === rhs
    }
    
    
    let user: User
    let message: [MessageRoom]
    let chat : ChatRoom
}
