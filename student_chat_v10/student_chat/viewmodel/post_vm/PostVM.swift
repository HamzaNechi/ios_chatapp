//
//  PostVM.swift
//  student_chat
//
//  Created by Mac Mini 1 on 24/4/2023.
//

import Foundation
import UIKit

final class PostVM: ObservableObject{
    @Published var posts: [PostModel] = []
    
    final var base_url: String = "http://172.17.1.113:9090"
    
    
    //add post sans image
    func addPostSansImage(content: String, user_id: String,completion : @escaping (Bool) -> ()){
        print("add post sans image start")
        guard let url = URL(string: "\(self.base_url)/post") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "description":content,
            "user":user_id,
            "author": user_id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                }
            }
        }
        task.resume()
    }
    
    //add post
    func addPost(content: String, user_id: String, img: UIImage, completion : @escaping (Bool) -> ()){
        // Convert the selected image to a Data object
           guard let imageData = img.jpegData(compressionQuality: 0.8) else {
               let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
               completion(false)
               return
           }
        
        // Create a boundary string for the multipart form-data request
            let boundary = UUID().uuidString

            // Create the request object and set its method and headers
            var request = URLRequest(url: URL(string: "\(self.base_url)/post")!)
            request.httpMethod = "POST"
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        // Create the request body as a Data object
           var body = Data()
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"description\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(content)\r\n".data(using: .utf8)!)
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"user\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(user_id)\r\n".data(using: .utf8)!)
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"author\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(user_id)\r\n".data(using: .utf8)!)
        
        
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

           // Set the request body and content length
           request.httpBody = body
           request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")
        
        // Create a URLSessionDataTask to perform the request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(false)
                    return
                }
                
                // Handle the response here
                guard let data = data else {
                      let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned from server"])
                      completion(false)
                      return
                  }
                  
                  do {
                      completion(true)
                  }
              }

              task.resume()
    }
    
    
    //delete post
    func deletePost(post_id: String,completion :@escaping(Bool) -> ()){
        print("delete posts start \(post_id)")
        guard let url = URL(string: "\(self.base_url)/post/delete/\(post_id)") else {
            print("Invalid URL")
            return
        }
        print("url = \(url)")
        let task = URLSession.shared.dataTask(with: url) { data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode getPost: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do{
                        completion(true)
                    }
                }else{
                    completion(false)
                }
                
                
            }
        }
        
        task.resume()
    }
    //share post
    func sharePost(post_id: String, user_id: String,completion :@escaping(Bool) -> ()){
        print("share posts start")
        guard let url = URL(string: "\(self.base_url)/post/share") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        
        
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "post":post_id,
            "user": user_id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                }
            }
        }
        task.resume()
    }
    
    //get author
    func getAuthor(author_id:String,completion :@escaping(String) -> ()){
        print("get author posts start")
        guard let url = URL(string: "\(self.base_url)/user/getuser") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        
        
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "id":author_id,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        let userResp = try JSONDecoder().decode(User.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(userResp.username)
                        }
                    }
                    catch{
                        print(error)
                    }
                }else{
                    completion("___")
                }
            }
        }
        task.resume()
    }
    
    
    //get all posts
        func fetch(completion : @escaping([PostModel]) -> ()) {
            print("fetch posts start")
            guard let url = URL(string: "\(self.base_url)/post") else {
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
                        let posts = try JSONDecoder().decode([PostModel].self, from: data)

                        DispatchQueue.main.async {
                            self?.posts = posts
                            completion(posts)
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
