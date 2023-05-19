//
//  User.swift
//  student_chat
//
//  Created by Mac Mini 6 on 13/4/2023.
//

import Foundation

class User : Hashable, Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs === rhs
    }
    
    
    let ActivationCode: String //
    let Banne: Bool //
    let Classe: String //10
    let Date_Naissance: String //9
    let Filiere: String //11
    let Genre: String //8
    let IsActive: Bool //
    let __v: Int //
    let _id: String //1
    let email: String //5
    let image: String //6
    let password: String //3
    let role: String //4
    let status: String //7
    let username: String //2
}
