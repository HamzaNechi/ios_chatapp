//
//  InvitationViewModel.swift
//  student_chat
//
//  Created by Mac Mini 2 on 5/5/2023.
//

import Foundation

final class InvitationViewModel: ObservableObject {
    @Published var invitations : [Invitation] = []
    final var base_url: String = "http://172.17.1.113:9090"
    
    
    //refuse invitation
    func refuseInvitation(inv_id: String, completion: @escaping (Bool) -> ()){
        print("refuse invitation")
        guard let url = URL(string: "\(self.base_url)/invitations/refuse") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "id":inv_id,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode refuse invi: \(httpResponse.statusCode)")
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
    
    //accept invitation
    
    func acceptRequest(inv_id: String, completion: @escaping (Bool) -> ()){
        print("accept invitation  start")
        guard let url = URL(string: "\(self.base_url)/invitations/accept") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "id":inv_id,
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
    
    
    func sendInvitation(destinataire: String, expediteur: String, completion: @escaping (Bool) -> ()){
        print("send invitation  start")
        guard let url = URL(string: "\(self.base_url)/invitations/send") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "destinataire":destinataire,
            "expediteur":expediteur,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode send invi: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 201){
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
    func getAllUserInvi(user_id:String , completion : @escaping ([Invitation]) -> ()){
        print("get all invitation start")
        guard let url = URL(string: "\(self.base_url)/invitations/\(user_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode get invitation: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200 ){
                    do{
                        let invis = try JSONDecoder().decode([Invitation].self, from: data)
                        print("size of invitations list = \(invis.count)")
                        DispatchQueue.main.async {
                            self?.invitations = invis
                            completion(invis)
                        }
                    }
                    catch{
                        completion([])
                        print("error \(httpResponse.statusCode)")
                        print(error)
                    }
                }
                
            }
            //convert to json
            
            
            
        }
        
        task.resume()
    }
}
