//
//  LikeViewModel.swift
//  student_chat
//
//  Created by Mac Mini 5 on 30/4/2023.
//

import Foundation
final class LikeViewModel: ObservableObject {
    @Published var likes : [Like] = []
    final var base_url: String = "http://172.17.1.113:9090"
    //add dislike
    func deleteLike(post_id: String, user_id: String, completion : @escaping (Bool) -> ()){
        print("dislike like start")
        guard let url = URL(string: "\(self.base_url)/like/delete") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "post":post_id,
            "user":user_id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 202){
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
    
    //add like
    func addLike(post_id: String, user_id: String, completion : @escaping (Bool) -> ()){
        print("add like start")
        guard let url = URL(string: "\(self.base_url)/like") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "post":post_id,
            "user":user_id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login: \(httpResponse.statusCode)")
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
    
    //get if user like post
    func isUserLikePost(post_id: String, user_id: String, completion : @escaping (Bool) -> ()){
        print("is likes start")
        guard let url = URL(string: "\(self.base_url)/like/islike/\(post_id)/\(user_id)") else {
            print("Invalid URL")
            return
        }
        
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        
                        completion(true)
                    }
                }else{
                    completion(false)
                    print(httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }
    
    
    //get all likes
    func getAllPostLikes(post_id:String , completion : @escaping ([Like]) -> ()){
        print("get all likes start")
        guard let url = URL(string: "\(self.base_url)/like/\(post_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode getPost: \(httpResponse.statusCode)")
                do{
                    let likes = try JSONDecoder().decode([Like].self, from: data)

                    DispatchQueue.main.async {
                        self?.likes = likes
                        completion(likes)
                    }
                }
                catch{
                    print(error)
                }
            }
            //convert to json
            
            
            
        }
        
        task.resume()
    }
}
