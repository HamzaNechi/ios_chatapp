//
//  profileView.swift
//  student_chat
//
//  Created by Mac Mini 11 on 14/4/2023.
//

import SwiftUI

struct profileView: View {
    //let _id: String
    //let image: String

    
    //personal
    @State private var _id: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var genre: String = ""
    @State private var birthdate=Date()
    
    @State private var status=UserDefaults.standard.string(forKey: "status") ?? "nil"
    @State private var shouldSendNewsletter = true
    @State private var url_image=UserDefaults.standard.string(forKey: "image") ?? "nil"
    //@State private var isOn = false
    //school
    @State private var classe=""
    @State private var filiere=""

    
    
    //image
    @State var shouldShowImagePicker = false
    @State var image:UIImage?
    
    @StateObject var viewModel = ProfileViewModel()
    @State var logout :Bool = false
    
    @State var deleteAccount : Bool = false
    @State var codeDeleteAccount : Int = Int.random(in: 111..<999)
    @State var textCodeDeleteAccount : String = ""
    
    var body: some View {
        NavigationView{
            Form{
                
                //Image
                HStack
                {
                    
                    
                    
                    HStack{
                        
                        if let image = self.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 143,height: 143)
                                .cornerRadius(80)
                        }else{
                            
                            AsyncImage(url: URL(string: self.url_image)){
                                image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 143,height: 143)
                                    .cornerRadius(80)
                            } placeholder: {
                                ProgressView()
                            }
                            
                                
                        }
                        
                    }
                    .overlay(RoundedRectangle(cornerRadius: 80)
                        .stroke(Color("Color1"), lineWidth : 3)
                    )
                    .onTapGesture {
                        shouldShowImagePicker.toggle()
                    }
                    .navigationViewStyle(StackNavigationViewStyle())
                    .fullScreenCover(isPresented: $shouldShowImagePicker, onDismiss: nil){
                        ImagePicker(image: $image)
                            .ignoresSafeArea()
                    }
                    .frame(width: 145,height: 145,alignment: .center)
                    
                }.padding(.horizontal, 80)
                    
                
                
               
                
                
                //personal information
                Section(header: Text("Personal Information")) {
                    TextField("Nom", text: $username).onAppear{
                        self.username = UserDefaults.standard.string(forKey: "username") ?? "nil"
                    }
                    TextField("Email", text: $email)
                        .disabled(true)
                        .onAppear{
                        self.email = UserDefaults.standard.string(forKey: "email") ?? "nil"
                    }
                    TextField("Genre", text: $genre).onAppear{
                        self.genre = UserDefaults.standard.string(forKey: "genre") ?? "nil"
                    }
                    
                    DatePicker("Date naissance" , selection: $birthdate, displayedComponents: .date).onAppear{
                        let dateFormatter = DateFormatter()
                          dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                          dateFormatter.dateFormat = "yyyy-MM-dd"
                        
                        let d = UserDefaults.standard.string(forKey: "birthDate") ?? "nil"
                        
                          let dateP = dateFormatter.date(from:d)
                        
                        let calendar = Calendar.current
                        let components = calendar.dateComponents([.year, .month, .day, .hour], from: dateP ?? Date())
                        
                        let finalDate = calendar.date(from:components)
                        
                        
                        self.birthdate = finalDate ?? Date()
                    }
                    
                }
                
                //school information
                Section(header: Text("School Information")) {
                    TextField("Filiére", text: $filiere).onAppear{
                        self.filiere = UserDefaults.standard.string(forKey: "filiere") ?? "nil"
                    }
                    TextField("Classe", text: $classe).onAppear{
                        self.classe = UserDefaults.standard.string(forKey: "classe") ?? "nil"
                    }
                }
                
                
                
                
                //actions
                Section(header: Text("Actions")) {
                    Toggle("Status en ligne", isOn: $shouldSendNewsletter).toggleStyle(SwitchToggleStyle(tint: .red))
                        .onChange(of: self.shouldSendNewsletter){
                            val in
                            viewModel.switchStatus(_id: self._id , status: val ? "En ligne" : "hors ligne")
                        }
                    
                    Button(action: {
                        viewModel.logOut(id: self._id)
                        let pref = UserDefaults.standard
                        pref.set("", forKey: "id")
                        pref.set("", forKey: "email")
                        pref.set("", forKey: "username")
                        pref.set("", forKey: "status")
                        pref.set("", forKey: "genre")
                        pref.set("", forKey: "birthDate")
                        pref.set("", forKey: "filiere")
                        pref.set("", forKey: "classe")
                        pref.set("", forKey: "image")
                       // self.logout = true
                        DispatchQueue.main.async {
                            let mySwiftUIIView = AuthView()
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIView)
                        }
                    }){
                        HStack{
                            Text("Log out").foregroundColor(Color("Secondary"))
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                    
                    
                    
                    Button("Supprimer compte"){
                        self.deleteAccount = true
                    }.alert("Supprimer compte", isPresented: self.$deleteAccount, actions: {
                        
                        
                        TextField("code",text: self.$textCodeDeleteAccount)
                        
                        Button("Annuler", action: {
                            print("annuler delete account")
                        })
                        
                        Button("Confirmer", action: {
                            let code = Int(self.textCodeDeleteAccount)
                            if(code == self.codeDeleteAccount){
                                print("you can delete")
                                viewModel.deleteAccount(_id: self._id)
                            }
                        })
                    }, message: {
                        Text("si tu es sur de supprimer votre compte écrire ce code ( \(self.codeDeleteAccount) ) et confirmer ")
                        
                    })
                    
                }
                
                
            }
            .accentColor(.red)
            .navigationTitle("Account")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Update", action: updateUser)
                        .foregroundColor(Color("Secondary"))
                        .foregroundColor(Color("accentColor"))
                    
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear{
                if(self.status == "En ligne"){
                    self.shouldSendNewsletter = true
                }
            }
            
            
        }
    }
    
    func updateUser(){
        print("id profile view \(_id)")
        let dateFormatter = DateFormatter()
        viewModel.updateUser(id: _id, username: username, email: email, genre: genre, classe: classe, filiere: filiere, dateN: dateFormatter.string(from: birthdate)){
            (resp) in
            //update shared preferences and binding value
            if(resp == true){
                let pref = UserDefaults.standard
                pref.set(self._id, forKey: "id")
                pref.set(self.email, forKey: "email")
                pref.set(self.username, forKey: "username")
                pref.set(self.status, forKey: "status")
                pref.set(self.genre, forKey: "genre")
                pref.set(self.birthdate, forKey: "birthDate")
                pref.set(self.filiere, forKey: "filiere")
                pref.set(self.classe, forKey: "classe")
            }else{
                //show alert
                print("resp == false")
            }
        }
    }
    
    struct ImagePicker : UIViewControllerRepresentable{
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            
        }
        
        
        @Binding var image: UIImage?
        
        let ctr = UIImagePickerController()
        
        func makeCoordinator() -> Coordinator {
            return Coordinator(parent : self)
        }
        
        class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
        {
            
            let parent : ImagePicker
            
            init(parent: ImagePicker) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                parent.image = info[.originalImage] as? UIImage
                picker.dismiss(animated: true)
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                picker.dismiss(animated: true)
            }
            
        }
        
        func makeUIViewController(context: Context) -> some UIViewController {
            ctr.delegate = context.coordinator
            return ctr
        }
    }
}



struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}
