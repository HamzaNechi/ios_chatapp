//
//  AuthView.swift
//  student_chat
//
//  Created by Mac Mini 6 on 14/4/2023.
//

import SwiftUI

struct Accueil: View{
    var body: some View{
        NavigationView{
            ZStack{
                Color.red
            }.navigationTitle("Accueil")
        }.navigationBarBackButtonHidden(true)
    }
}

struct homeView: View {
    
    @StateObject var viewModel = AuthViewModel()
    
    var body: some View {
        
        TabView{
            postView()
                .tabItem{
                    Image(systemName: "house")
                    Text("Accueil")
                }
            
            messageView()
                .tabItem{
                    Image(systemName: "message")
                    Text("Discussions")
                }
            
            
            contactView()
                .tabItem{
                    Image(systemName: "person.2")
                    Text("Contacts")
                }
            
            
            profileView()
                .tabItem{
                    Image(systemName: "person")
                    Text("Profile")
                }
        }.accentColor(Color("Color1"))
            
        
        
    }
    
   
      
}



struct homeView_Previews: PreviewProvider {
    
    static var previews: some View {
        homeView()
    }
}

/**
 NavigationView{
     List{
         ForEach(viewModel.courses, id: \.self){
             course in
             VStack{
                 Text(course.title).bold()
                 Text(course.body).bold()
             }
             .padding(3)
         }
     }.navigationTitle("Courses")
         .onAppear{
             viewModel.fetch()
         }
 }
 .navigationTitle("")
 .navigationBarBackButtonHidden(true)
 .navigationBarHidden(true)
 */
