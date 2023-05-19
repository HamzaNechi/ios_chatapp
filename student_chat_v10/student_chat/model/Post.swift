//
//  Post.swift
//  student_chat
//
//  Created by Mac Mini 1 on 24/4/2023.
//

import Foundation
class PostModel: Hashable,Codable,Identifiable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: PostModel, rhs: PostModel) -> Bool {
        return lhs === rhs
    }
    
    let _id : String
    let image : String
    let description : String
    let date : String
    let user : User
    let author : String
}
