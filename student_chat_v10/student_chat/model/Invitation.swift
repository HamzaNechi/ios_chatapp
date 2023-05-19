//
//  Invitation.swift
//  student_chat
//
//  Created by Mac Mini 2 on 5/5/2023.
//

import Foundation


class Invitation : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Invitation, rhs: Invitation) -> Bool {
        return lhs === rhs
    }
    
    let _id: String
    let expediteur: User
    let destinataire: User
    let status: String
    let date: String
}
