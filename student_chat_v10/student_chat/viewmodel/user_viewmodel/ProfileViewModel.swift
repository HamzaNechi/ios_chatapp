//
//  ProfileViewModel.swift
//  student_chat
//
//  Created by Mac Mini 11 on 14/4/2023.
//

import Foundation
import UIKit
import SwiftUI


final class ProfileViewModel: ObservableObject{
    
    final var base_url: String = "http://172.17.1.113:9090"
    
    //delete account user
    func deleteAccount(_id : String){
        print("delete user \(_id)")
        guard let url = URL(string: "\(self.base_url)/user/delete") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "id": _id,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            if let HttpResponse = response as? HTTPURLResponse{
                if(HttpResponse.statusCode == 200){
                    DispatchQueue.main.async {
                        let mySwiftUIIView = AuthView()
                        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIView)
                    }
                }
            }
        }//end task
        task.resume()
    }
    
    //switch status user
    func switchStatus(_id : String, status : String){
        print("update status user view model \(_id)")
        guard let url = URL(string: "\(self.base_url)/user/switch_status") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "id": _id,
            "status" : status
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            print("switch updated")
        }//end task
        task.resume()
    }
    
    func updateUser(id: String , username: String, email: String, genre: String, classe: String, filiere: String, dateN: String, completion: @escaping (Bool) -> ()){
        
        print("update user view model \(id)")
        guard let url = URL(string: "\(self.base_url)/api/user/updateUser") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "userId": id,
            "Username": username,
            "Email": email,
            "Genre": genre,
            "Classe": classe,
            "Filiere":  filiere,
            "Date_Naissance": dateN,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode update profile : \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        completion(true)
                    }
                    catch{
                        completion(false)
                        print(error)
                    }
                }else{
                    completion(false)
                    print(httpResponse.statusCode)
                }
            }
            
        }//end task
        task.resume()
    }
    
    
    
    func logOut(id:String){
        print("update status \(id)")
        guard let url = URL(string: "\(self.base_url)/user/logout") else{
            return
        }
        print("url update status \(url)")
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "id": id,
            
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in

            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode update status: \(httpResponse.statusCode)")

            }
            
        }//end task
        task.resume()
    }
}
