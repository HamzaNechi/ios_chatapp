//
//  DataSingleton.swift
//  student_chat
//
//  Created by Mac Mini 5 on 26/4/2023.
//

import Foundation


class DataSingleton{
    static let shared = DataSingleton()
    
    var usename: String?
    var email: String?
    var password: String?
    
}
