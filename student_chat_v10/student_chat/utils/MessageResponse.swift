//
//  MessageResponse.swift
//  student_chat
//
//  Created by Mac Mini 3 on 7/5/2023.
//

import Foundation
class MessageResponse : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: MessageResponse, rhs: MessageResponse) -> Bool {
        return lhs === rhs
    }
    
    
    let message : MessageRoom
}
