//
//  AmisViewModel.swift
//  student_chat
//
//  Created by Mac Mini 2 on 6/5/2023.
//

import Foundation
final class AmisViewModel: ObservableObject {
    
    @Published var amis : [User] = []
    final var base_url: String = "http://172.17.1.113:9090"
    
    
    //get or create room chat
    func getOrCreateRoom(current_user: String, amis_user: String, completion : @escaping (String) -> ()){
        print("get or create room start")
        guard let url = URL(string: "\(self.base_url)/chat") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "currentUser":current_user,
            "chatUser":amis_user
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode get chat room: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200 ){
                    do{
                        let chat_id = try JSONDecoder().decode(String.self, from: data)
                        DispatchQueue.main.async {
                            completion(chat_id)
                        }
                    }
                    catch{
                        completion("")
                        print("error get chat id room \(httpResponse.statusCode)")
                        print(error)
                    }
                }
                
            }
        }
        task.resume()
    }
    //delete amis
    
    func deleteAmis(currentUser_id: String, amis_id: String,completion: @escaping (Bool) -> ()){
        print("delete amis  start")
        guard let url = URL(string: "\(self.base_url)/amis/delete") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "currentUser":currentUser_id,
            "userDelete":amis_id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode accept invi: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        completion(true)
                    }
                }else{
                    completion(false)
                }
            }
        }
        task.resume()
    }
  
    
    
    
    //get all invitation
    func getAllUserAmis(user_id:String , completion : @escaping ([User]) -> ()){
        print("get all amis start")
        guard let url = URL(string: "\(self.base_url)/amis/\(user_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode get amis: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200 ){
                    do{
                        let amis = try JSONDecoder().decode([User].self, from: data)
                        print("size of amis list = \(amis.count)")
                        DispatchQueue.main.async {
                            self?.amis = amis
                            completion(amis)
                        }
                    }
                    catch{
                        completion([])
                        print("error get all amis \(httpResponse.statusCode)")
                        print(error)
                    }
                }
                
            }
            //convert to json
            
            
            
        }
        
        task.resume()
    }
}
