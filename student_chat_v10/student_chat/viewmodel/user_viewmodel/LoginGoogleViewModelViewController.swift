//
//  LoginGoogleViewModelViewController.swift
//  student_chat
//
//  Created by Mac Mini 2 on 17/5/2023.
//

import UIKit
import SwiftUI

class LoginGoogleViewModelViewController: UIViewController {
    final var base_url: String = "http://172.17.1.113:9090"
    private var genre : String = "";
    private var classe : String = "";
    private var filiere : String = "";
    private var date : String = "";
    private var email :String = UserDefaults.standard.string(forKey: "userEmailGoogle")!

    @IBOutlet weak var genreOutlet: UISegmentedControl!
    
    @IBOutlet weak var classButton: UIButton!
    
    @IBOutlet weak var birthOutlet: UIDatePicker!
    
    @IBOutlet weak var filiereButton: UIButton!
    @IBAction func birthDateAction(_ sender: Any) {
    }
    
    @IBAction func filiereAction(_ sender: Any) {
    }
    
    @IBAction func classeAction(_ sender: Any) {
    }
    
    @IBAction func LoginAction(_ sender: Any) {
        if(genreOutlet.selectedSegmentIndex == 1){
            self.genre = "Femme"
        }else{
            self.genre = "Homme"
        }
        let dateNaiss = birthOutlet.date
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd/MM/YYYY"
        print("date naissance \(dateFormatter2.string(from: dateNaiss))")
        loginStepTwho(genre: self.genre, date: dateFormatter2.string(from: dateNaiss), classe: self.classe, filiere: self.filiere){
            logged in
            if(logged){
                DispatchQueue.main.async {
                    let mySwiftUIIView = homeView()
                    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIView)
                }
            }
        }
        
    }
    
    
    func loginStepTwho(genre: String , date : String , classe : String , filiere : String, completion : @escaping (Bool) -> ()){
        print("fonction login google start")

        let url = URL(string: "\(self.base_url)/user/login/google/update")
        
        var request = URLRequest(url: url!)
        
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "email":self.email,
            "genre":genre,
            "birthDate":date,
            "classe":classe,
            "filiere":filiere
            
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode login google: \(httpResponse.statusCode)")
                if(httpResponse.statusCode != 400){
                    //convert to json
                    do{
                        let userInfo = try JSONDecoder().decode(User.self, from: data!)
                        print("login gogle error \(userInfo.IsActive)")
                       let pref = UserDefaults.standard
                        pref.set(userInfo._id, forKey: "id")
                        pref.set(userInfo.email, forKey: "email")
                        pref.set(userInfo.username, forKey: "username")
                        pref.set(userInfo.status, forKey: "status")
                        pref.set(userInfo.Genre, forKey: "genre")
                        pref.set(userInfo.Date_Naissance, forKey: "birthDate")
                        pref.set(userInfo.Filiere, forKey: "filiere")
                        pref.set(userInfo.Classe, forKey: "classe")
                        pref.set(userInfo.image, forKey: "image")
                        
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                    catch{
                        print(error)
                    }
                }else{
                    completion(false)
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classButton.menu = addMenuItemsClasse()
        filiereButton.menu = addMenuItemsFiliere()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func addMenuItemsClasse() -> UIMenu{
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            
            UIAction(title: "4eme1",handler: {i in
                self.classe = i.title
                self.classButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "4eme2",handler: {i in
                self.classe = i.title
                self.classButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "4eme3",handler: {i in
                self.classe = i.title
                self.classButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "5eme1",handler: {i in
                self.classe = i.title
                self.classButton.setTitle(i.title, for: .normal)
            })
        ])
        return menuItems
    }
    
    
    func addMenuItemsFiliere() -> UIMenu{
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            
            UIAction(title: "SIM",handler: {i in
                self.filiere = i.title
                self.filiereButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "TWIN",handler: {i in
                self.filiere = i.title
                self.filiereButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "DS",handler: {i in
                self.filiere = i.title
                self.filiereButton.setTitle(i.title, for: .normal)
            }),
            UIAction(title: "GAMIX",handler: {i in
                self.filiere = i.title
                self.filiereButton.setTitle(i.title, for: .normal)
            })
        ])
        return menuItems
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
