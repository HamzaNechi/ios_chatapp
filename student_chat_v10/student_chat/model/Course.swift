//
//  Course.swift
//  student_chat
//
//  Created by Mac Mini 6 on 14/4/2023.
//

import Foundation

class Course: Hashable,Codable{
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(ObjectIdentifier(self))
    }
    
    static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs === rhs
    }
    
    let userId : Int
    let id : Int
    let title : String
    let body : String
}
