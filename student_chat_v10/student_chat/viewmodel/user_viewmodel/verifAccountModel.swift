//
//  verifAccountModel.swift
//  student_chat
//
//  Created by Mac Mini 1 on 17/4/2023.
//

import Foundation
//
//  AuthViewModel.swift
//  student_chat
//
//  Created by Mac Mini 6 on 13/4/2023.

final class VerifAccountModel: ObservableObject{
    final var base_url: String = "http://172.17.1.113:9090"
    
    func activate(Activation:String, completion: @escaping (Bool) -> ()){
        
        print("update user view model \(Activation)")
        guard let url = URL(string: "\(self.base_url)/Activation") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            //postman;fonction
            "ActivationCode": Activation,
            
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode compte activated: \(httpResponse.statusCode)")
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
    
}
