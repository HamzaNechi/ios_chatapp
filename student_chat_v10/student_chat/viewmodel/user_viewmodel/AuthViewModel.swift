//
//  AuthViewModel.swift
//  student_chat
//
//  Created by Mac Mini 6 on 13/4/2023.
//

import Foundation
import UIKit
import Vision
import GoogleSignIn
import SwiftUI

final class AuthViewModel: ObservableObject{
    @Published var courses: [Course] = []
    @Published var user: User?
    @Published var isStudent: Bool = false
    
    final var base_url: String = "http://172.17.1.113:9090"
    var responseCode : Int = 0
    
    //login google
    func handleSignInButton() {
        let signInConfig = GIDConfiguration.init(clientID: "671779866539-j7gt6qu2hkstungk9uko3fvb1cisbtvn.apps.googleusercontent.com")
    
    GIDSignIn.sharedInstance.configuration = signInConfig;
        GoogleSignIn.GIDSignIn.sharedInstance.signIn(
        withPresenting: ApplicationUtility.rootViewController) { signInResult, error in
            guard signInResult != nil else {
            // Inspect error
            return
          }
            let userFullName = signInResult?.user.profile?.name
            UserDefaults.standard.set(userFullName, forKey: "userFullNameGoogle")
            let userEmail = signInResult?.user.profile?.email
            let userImage = signInResult?.user.profile?.imageURL(withDimension: 150)
            UserDefaults.standard.set(userEmail, forKey: "userEmailGoogle")
            
            if((userEmail?.contains("@esprit.tn")) != nil){
                self.firstStepLoginGoogle(username: userFullName!, email: userEmail!, image: userImage!.absoluteString){
                    user in
                    
                    if(user.Genre != "_"){
                        let pref = UserDefaults.standard
                        pref.set(user._id, forKey: "id")
                        pref.set(user.email, forKey: "email")
                        pref.set(user.username, forKey: "username")
                        pref.set(user.status, forKey: "status")
                        pref.set(user.Genre, forKey: "genre")
                        pref.set(user.Date_Naissance, forKey: "birthDate")
                        pref.set(user.Filiere, forKey: "filiere")
                        pref.set(user.Classe, forKey: "classe")
                        pref.set(user.image, forKey: "image")
                        
                        DispatchQueue.main.async {
                            let mySwiftUIView = homeView()
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIView)
                        }
                    }else{
                        let storyboard = UIStoryboard(name: "LoginGoogle", bundle: nil)
                                   let loginGoogleViewController = storyboard.instantiateViewController(withIdentifier: "LoginGoogle") as! LoginGoogleViewModelViewController
                                   ApplicationUtility.rootViewController.present(loginGoogleViewController, animated: true, completion: nil)
                    }
                }
            }
            
            
            //
            
            
        }
      
    }
    
    
    func firstStepLoginGoogle(username : String , email : String , image : String ,completion : @escaping (User) -> ()){
        print("fonction login google start")

        let url = URL(string: "\(self.base_url)/user/login/google")
        
        var request = URLRequest(url: url!)
        
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "username":username,
            "email":email,
            "image":image
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login google: \(httpResponse.statusCode)")
                if(httpResponse.statusCode != 405){
                    //convert to json
                    do{
                        let user = try JSONDecoder().decode(User.self, from: data!)
                        
                        DispatchQueue.main.async {
                            completion(user)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
        }
        task.resume()
    }
    //end login google
    
    
    func recogniseText(image: UIImage, completion: @escaping (Bool) -> ()){
        
            guard let cgImage = image.cgImage else {
                return
            }
            let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage , orientation: .up)
            let size = CGSize(width: cgImage.width, height: cgImage.height)
            let bounds = CGRect(origin: .zero , size: size)
            
            let request = VNRecognizeTextRequest{ request, error in
                guard let results = request.results as? [VNRecognizedTextObservation],
                      error == nil else {
                    return
                }
                let string = results.compactMap{
                    $0.topCandidates(1).first?.string
                }.joined(separator: "\n")
                print(string)
                
                // compare the recognized text with a specific text and verify the condition CARTE ÉTUDIANT
                if (string.contains("Année universitaire 2021/2022")) {
                    print("ocr fel if")
                    completion(true)
                } else {
                    print("ocr fel else")
                    completion(false)
                }
            }
            DispatchQueue.global( qos: .userInitiated).async {
                do{
                    try imageRequestHandler.perform([request])
                }catch {
                    print("Failed to perform image request : \(error)")
                    return
                }
            }
        }
    
    func fetch() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , _, error in
            guard let data = data, error == nil else {
                return
            }
            
            
            //convert to json
            do{
                let courses = try JSONDecoder().decode([Course].self, from: data)
                
                DispatchQueue.main.async {
                    self?.courses = courses
                }
            }
            catch{
                print(error)
            }
            
            
        }
        
        task.resume()
    }
    
    
    //register
    func register(img: UIImage,username :String,email:String, password:String,genre : String, classe : String,filiere:String,dateN:String,completion: @escaping (User?)->()){
        
        // Convert the selected image to a Data object
           guard let imageData = img.jpegData(compressionQuality: 0.8) else {
               let error = NSError(domain: "com.example.app", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Data"])
               return
           }
        
        // Create a boundary string for the multipart form-data request
        let boundary = UUID().uuidString

        // Create the request object and set its method and headers
        var request = URLRequest(url: URL(string: "\(self.base_url)/register")!)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        
        // Create the request body as a Data object
           var body = Data()
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"Username\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(username)\r\n".data(using: .utf8)!)
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"Email\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(email)\r\n".data(using: .utf8)!)
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"Password\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(password)\r\n".data(using: .utf8)!)
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"Genre\"\r\n\r\n".data(using: .utf8)!)
           body.append("\(genre)\r\n".data(using: .utf8)!)
        
          body.append("--\(boundary)\r\n".data(using: .utf8)!)
          body.append("Content-Disposition: form-data; name=\"Classe\"\r\n\r\n".data(using: .utf8)!)
          body.append("\(classe)\r\n".data(using: .utf8)!)
        
        
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"Filiere\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(filiere)\r\n".data(using: .utf8)!)
        
          body.append("--\(boundary)\r\n".data(using: .utf8)!)
          body.append("Content-Disposition: form-data; name=\"Date_Naissance\"\r\n\r\n".data(using: .utf8)!)
          body.append("\(dateN)\r\n".data(using: .utf8)!)
        
        
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
                guard let data = data, error == nil else {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse{
                    print("statusCode register: \(httpResponse.statusCode)")
                    if(httpResponse.statusCode == 201){
                        do {
                            let userResp = try JSONDecoder().decode(User.self, from: data)
                            completion(userResp)
                        }
                        catch{
                            completion(nil)
                            print(error)
                        }
                    }else{
                        completion(nil)
                        print(httpResponse.statusCode)
                    }
                }
              }

              task.resume()
        //code jdid
        
    }
    
    
    //login
    func login(email: String,pass: String,completion: @escaping (User?)->()) {
        print("fonction login start")
        guard let url = URL(string: "\(self.base_url)/login") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "Username":email,
            "Password":pass
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200){
                    do {
                        let userResp = try JSONDecoder().decode(User.self, from: data)
                        completion(userResp)
                        DispatchQueue.main.async {
                            self?.user = userResp
                        }
                    }
                    catch{
                        print(error)
                    }
                }else{
                    self?.user = nil
                    completion(nil)
                    print(httpResponse.statusCode)
                }
            }
        }
        task.resume()
    }
    
    
    
    //forget password
    func forgetPassword(code: String,pass: String,completion: @escaping (Bool)->()) {
        print("fonction login start")
        guard let url = URL(string: "\(self.base_url)/resetpassword") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "ActivationCode":code,
            "Password":pass
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode reset: \(httpResponse.statusCode)")
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
    
    
    
    //find email
    func findEmail(email: String,completion: @escaping (Bool)->()) {
        print("fonction login start")
        guard let url = URL(string: "\(self.base_url)/findEmail") else{
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "Email":email,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode reset: \(httpResponse.statusCode)")
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
        }
        task.resume()
    }
}
