//
//  CommentViewModel.swift
//  student_chat
//
//  Created by Mac Mini 5 on 30/4/2023.
//

import Foundation
final class CommentViewModel: ObservableObject {
    @Published var comments : [Comment] = []
    final var base_url: String = "http://172.17.1.113:9090"
    var id_user_cnnected = UserDefaults.standard.string(forKey: "id") ?? "nil"
    
    
    
    //delete comment
    func deleteComment(comment_id: String,completion : @escaping (String) -> ()){
        print("delete comment start")
        guard let url = URL(string: "\(self.base_url)/comment/delete/\(comment_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) {data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode deletecomment: \(httpResponse.statusCode)")
                do{
                    let comm = try JSONDecoder().decode(String.self, from: data)

                    DispatchQueue.main.async {
                        completion(comm)
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
    
    //add comment
    func addComment(post_id: String, content: String ,completion : @escaping (Bool) -> ()){
        print("add comment start")
        guard let url = URL(string: "\(self.base_url)/comment") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "post":post_id,
            "user":id_user_cnnected,
            "content": content
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
    
    //get coments for one post
    func getComments(post_id: String, completion : @escaping ([Comment]) -> ()){
        print("fetch comment start")
        guard let url = URL(string: "\(self.base_url)/comment/\(post_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode getComment: \(httpResponse.statusCode)")
                do{
                    let comm = try JSONDecoder().decode([Comment].self, from: data)

                    DispatchQueue.main.async {
                        completion(comm)
                        self?.comments = comm
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
