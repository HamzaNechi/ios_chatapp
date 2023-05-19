//
//  student_chatApp.swift
//  student_chat
//
//  Created by Mac Mini 6 on 13/4/2023.
//

import SwiftUI
import GoogleSignIn

@main
struct student_chatApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
           // homeView()
            AuthView()
            //ForgetPassword()
            //verifAcount()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onOpenURL { url in
                          GIDSignIn.sharedInstance.handle(url)
                        }
                .onAppear {
                          GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                            // Check if `user` exists; otherwise, do something with `error`
                          }
                        }
            
            
        }
    }
    
    struct storyboardview: UIViewControllerRepresentable{
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            let storyboard = UIStoryboard(name: "LoginGoogle", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginGoogleViewModelViewController")
            return controller
            
        }
        
        
    }
}
