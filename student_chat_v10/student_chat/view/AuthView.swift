//
//  ContentView.swift
//  Login App
//
//  Created by Kavsoft on 13/06/20.
//  Copyright © 2020 Kavsoft. All rights reserved.
//

import SwiftUI
import GoogleSignIn


//732033080468-albitpt0inbumhdvteqi6e315opkicb3.apps.googleusercontent.com
struct AuthView: View {
    
    
    var body: some View {
        NavigationView {
            //NavigationLink(destination: storyboardview()) {
                
                Home()                
            //}
        }.navigationBarBackButtonHidden(true)
    }
    
}



//    struct storyboardview: UIViewControllerRepresentable{
//        func makeUIViewController(context: UIViewControllerRepresentableContext<storyboardview>) ->
//        UIViewController {
//            let storyboard = UIStoryboard( name:"Storyboard",bundle: nil)
//            let controller = storyboard.instantiateViewController(withIdentifier: "Home")
//            return controller
//
//        }
//        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<storyboardview>) {
//
//        }
//    }

    struct AuthView_Previews: PreviewProvider {
        
        static var previews: some View {
            AuthView()
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
    
    struct Home : View {
        
        @State var index = 0
        @StateObject var viewModel = AuthViewModel()
        
        var body: some View{
            
            
                
            
            GeometryReader{_ in
                
                VStack{
                    
                
                    
                    ZStack{
                        
                        SignUP(index: self.$index)
                        // changing view order...
                            .zIndex(Double(self.index))
                        
                        Login(index: self.$index)
                        
                    }
                    
                    HStack(spacing: 5){
                        
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                        
                        Text("OR")
                            .padding()
                            .foregroundColor(Color("Secondary"))
                        
                        Rectangle()
                            .fill(Color("Color1"))
                            .frame(height: 1)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    // because login button is moved 25 in y axis and 25 padding = 50
                    
                    HStack(spacing: 25){
                        Button(action: {
                            viewModel.handleSignInButton()
                        }) {
                            
                            Image("google")
                                .resizable()
                                .renderingMode(.original)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                    .padding(.top, 0)
                }
                .padding(.vertical)
            }
        }
    }

    // Curve...
    
    struct CShape : Shape {
        
        func path(in rect: CGRect) -> Path {
            
            return Path{path in
                
                // right side curve...
                
                path.move(to: CGPoint(x: rect.width, y: 100))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: 0, y: 0))
                
            }
        }
    }
    
    
    struct CShape1 : Shape {
        
        func path(in rect: CGRect) -> Path {
            
            return Path{path in
                
                // left side curve...
                
                path.move(to: CGPoint(x: 0, y: 100))
                path.addLine(to: CGPoint(x: 0, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: rect.height))
                path.addLine(to: CGPoint(x: rect.width, y: 0))
                
            }
        }
    }
    
    
    struct Login : View {
        
        
        
        
        @State var email = ""
        @State var pass = ""
        @State var areYouGoingToSecondView: Bool = false
        @Binding var index : Int
        @StateObject var viewModel = AuthViewModel()
        @State var goVerif: Bool = false
        
        var body: some View{
            
         
            
            ZStack(alignment: .bottom) {
                
                VStack{
                    
                    HStack{
                        
                        VStack(spacing: 250){
                            
                            Text("Login")
                                .foregroundColor(self.index == 0 ? Color("Secondary") : .gray)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Capsule()
                                .fill(self.index == 0 ? Color.blue : Color.clear)
                                .frame(width: 0, height: 5)
                        }
                        Image("logo")
                            .resizable()
                            .frame(width: 180, height: 180)
                            .padding(.top,80)

                            
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 30)// for top curve...
                    
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            Image(systemName: "envelope.fill")
                                .foregroundColor(Color("Color1"))
                            
                            TextField("Email Address", text: self.$email)
                                .foregroundColor(Color("Secondary"))
                        }
                        
                        Divider().background(Color.accentColor.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    
                    VStack{
                        
                        HStack(spacing: 15){
                            
                            Image(systemName: "eye.slash.fill")
                                .foregroundColor(Color("Color1"))
                            
                            SecureField("Password", text: self.$pass)
                                .foregroundColor(Color("Secondary"))
                        }
                        
                        Divider().background(Color.accentColor.opacity(0.5))
                    }
                    .padding(.horizontal)
                    .padding(.top, 30)
                    
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        NavigationLink(destination: verifEmail(),isActive: self.$goVerif){
                            
                        }
                        Button(action: {
                            self.goVerif = true
                            
                        }) {
                            
                            Text("Forget Password?")
                                .foregroundColor(Color("Secondary").opacity(0.6))
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding()
                // bottom padding...
                .padding(.bottom, 65)
                .background(Color("Color2"))
                .clipShape(CShape())
                .contentShape(CShape())
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    
                    self.index = 0
                    
                }
                .cornerRadius(35)
                .padding(.horizontal,20)
                
                // Button...
                NavigationLink(destination: homeView(), isActive: $areYouGoingToSecondView) {
                    
                }
                
                
                Button(action: {

                    viewModel.login(email: email, pass: pass) { (user) in
                        if(user != nil){
                            let pref = UserDefaults.standard
                            pref.set(user?._id, forKey: "id")
                            pref.set(user?.email, forKey: "email")
                            pref.set(user?.username, forKey: "username")
                            pref.set(user?.status, forKey: "status")
                            pref.set(user?.Genre, forKey: "genre")
                            pref.set(user?.Date_Naissance, forKey: "birthDate")
                            pref.set(user?.Filiere, forKey: "filiere")
                            pref.set(user?.Classe, forKey: "classe")
                            pref.set(user?.image
                                     , forKey: "image")
                            
                            //navigation to home
                           // self.areYouGoingToSecondView = true
                            DispatchQueue.main.async {
                                let mySwiftUIIView = homeView()
                                UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIView)
                            }
                        }else{
                            print("user nil in login")
                        }
                        
                    }
                           
                }) {
                    
                    Text("LOGIN")
                        .foregroundColor(.white)
                        //.foregroundColor(Color("accentColor"))
                        .fontWeight(.bold)
                        .padding(.vertical)
                        .padding(.horizontal, 50)
                        .background(Color("Color1"))
                        .clipShape(Capsule())
                    // shadow...
                        .shadow(color: Color.accentColor.opacity(0.1), radius: 5, x: 0, y: 5)
                }
                // moving view down..
                .offset(y: 25)
                .opacity(self.index == 0 ? 1 : 0)
                
            }
        }
        

    }

    
    // SignUP Page..
    
    struct SignUP : View {
        
        @State var email = ""
        @State var username = ""
        @State var password = ""
        @State var repass = ""
        @State var filiere = ""
        @State var genre = ""
        @State var classe = ""
        @State var DateNai = Date()
        @Binding var index : Int
        @State private var selection = 0
        let options = ["SIM","TWIN","DS"]
        
        @State private var selectionClasse = 0
        let optionsClasse = ["1ere","2eme","3eme","4eme","5eme"]
        
        
        //genre
        @State private var selectionGenre = 0
        var optionsGenre = ["Homme","Femme"]
        
        
        //image
        @State var shouldShowImagePicker = false
        @State var image:UIImage?
        
        @State var areYouGoingToSecondView: Bool = false
        @StateObject var viewModel = AuthViewModel()

        
        
        //ocr carte etudiant
        @State var carte : UIImage?
        @State var showOcrPicker: Bool = false
        @State var etudiant : Bool = false
        @State var lunchOcr : Bool = false
        
        
        //verif emmail
        @State var alertInvalidEmail  : Bool = false
        var body: some View{
            
            ZStack(alignment: .bottom) {
                
                VStack{
                    
                    HStack{
                        
                        Spacer(minLength: 0)
                        
                        VStack(spacing: 10){
                            
                            Text("SignUp")
                                .foregroundColor(self.index == 1 ? Color("Secondary") : .gray)
                                .font(.title)
                                .fontWeight(.bold)
                            
                            Capsule()
                                .fill(self.index == 1 ? Color.blue : Color.clear)
                                .frame(width: 100, height: 5)
                        }
                    }
                    .padding(.top, 20)
                    
                    
                    
                  //start Form
                    
                    
                    ScrollView{
                        
                        
                        //compte form
                        
                        //Image
                        HStack{
                         if let image = self.image {
                          Image(uiImage: image)
                              .resizable()
                              .scaledToFill()
                              .frame(width: 100,height: 100)
                              .cornerRadius(50)
                          }else{
                             Image(systemName: "person.fill")
                               .font(.system(size: 50))
                               .padding()
                              .foregroundColor(Color("Color1"))
                              
                          }
                                            
                         }
                         .overlay(RoundedRectangle(cornerRadius: 50)
                             .stroke(Color("Color1"), lineWidth : 1)
                         )
                         .onTapGesture {
                             shouldShowImagePicker.toggle()
                         }
                         .sheet(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                             ImagePicker(image: $image)
                                // .ignoresSafeArea()
                         }
                        .frame(width: 100,height: 100,alignment: .center)
                        .padding(.top,50)
                        
                        
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "person")
                                    .foregroundColor(Color("Color1"))
                                
                                TextField("Enter your username", text: self.$username)
                                    
                                    
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        
                        //email
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "envelope")
                                    .foregroundColor(Color("Color1"))
                                
                                TextField("Email Address", text: self.$email)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        
                        
                        //password
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "pencil.and.ellipsis.rectangle")
                                    .foregroundColor(Color("Color1"))
                                
                                SecureField("Mot de passe", text: self.$password)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        //end compte from
                        //personal form
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        //date de naissance
                        
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                Image(systemName: "clock")
                                    .foregroundColor(Color("Color1"))
                                
                                DatePicker("Naissance" , selection: $DateNai, displayedComponents: .date)
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        //end personal form
                        //school form
                        
                        //genre
                        VStack{
                            
                            HStack(spacing: 15){
                                
                                
                                
                                Picker("Select genre", selection: $selectionGenre) {
                                    ForEach(0..<2)
                                    { index in
                                        Text(optionsGenre[index]).tag(index)
                                        
                                    }
                                }
                                Text(optionsGenre[selectionGenre])
                                //TextField("Genre", text: self.$genre)
                                Spacer()
                            }
                            
                            Divider().background(Color.white.opacity(0.5))
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        
                        //filiere
                        VStack{
                            
                            HStack(spacing: 0) {
                                
                                
                                Picker("Select an option", selection: $selection) {
                                    ForEach(0..<options.count) { index in
                                        Text(options[index]).tag(index)
                                        
                                    }
                                }
                                Text("Selected option : \(options[selection])")
                                //filiere=options[selection]
                                Spacer()
                            }
                            
                            
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        
                   
                        
                        //calasse


                        VStack{
                            
                            HStack(spacing: 15) {
                                
                                
                                Picker("Select an Classe", selection: $selectionClasse) {
                                    ForEach(0..<optionsClasse.count) { index in
                                        Text(optionsClasse[index]).tag(index)
                                        
                                    }
                                }
                                Text("Selected option : \(optionsClasse[selectionClasse])")
                                //filiere=options[selection]
                                Spacer()
                            }
                            
                            
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        //end school form
                        
                        
                        
                        //ocr start
                        VStack{
                            
                            HStack(spacing: 15) {
                                
                                Button(action: {
                                    showOcrPicker.toggle()

                                }, label: {
                                    Text("Carte étudiant ?")
                                        .foregroundColor(.blue)
                                }).sheet(isPresented: $showOcrPicker, onDismiss: nil) {
                                    ImagePicker(image: $carte)

                                }
                                .onChange(of: carte) {
                                    if let img = $0 {
                                        print("carte changed")
                                        //ocr
                                        viewModel.recogniseText(image: carte!){rs in
                                            print("image picker \(rs)")

                                            self.lunchOcr = rs
                                        }
                                    }

                                }
                                
                                Spacer()
                                //symbol accept or not
                                if(self.lunchOcr){
                                    Image("tic")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                }else{
                                    Image("cross")
                                        .resizable()
                                        .frame(width: 30,height: 30)
                                }
                                
                                
                            }
                            
                            
                            
                            Divider().background(Color.white.opacity(0.5))
                        }
                        .padding(.horizontal,30)
                        .padding(.top, 10)
                        //ocr end
                        
                    }
                        
                    
                    
                    //end form
                    
                    
                }
                .padding()
                // bottom padding...
                .padding(.bottom, 65)
                .background(Color("Color2"))
                .clipShape(CShape1())
                // clipping the content shape also for tap gesture...
                .contentShape(CShape1())
                // shadow...
                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                .onTapGesture {
                    
                    self.index = 1
                    
                }
                .cornerRadius(35)
                .padding(.horizontal,20)
                
                // Button...
                NavigationLink(destination: verifAcount(), isActive: $areYouGoingToSecondView) {
                    
                }
                
                //signup or next button
                VStack{
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        if(self.lunchOcr){
                            if(self.isEspritEmail(email: self.email)){
                                viewModel.register(img: image!,username: username, email: email, password: password, genre: optionsGenre[selectionGenre], classe: optionsClasse[selectionClasse], filiere: options[selection], dateN: dateFormatter.string(from: DateNai)){
                                    (user) in
                                    if(user != nil){
                                        print("sign up mrigle")
                                        self.areYouGoingToSecondView = true
                                    }
                                    
                                }
                            }else{
                                self.alertInvalidEmail = true
                            }
                            
                        }else{
                            print("show alert verif your carte etudiant")
                        }
                        
                    }) {
                        
                        Text("SIGNUP")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical)
                            .padding(.horizontal, 50)
                            .background(Color("Color1"))
                            .clipShape(Capsule())
                        // shadow...
                            .shadow(color: Color.white.opacity(0.1), radius: 5, x: 0, y: 5)
                    }
                    .alert("Invalid email", isPresented: self.$alertInvalidEmail, actions: {
                        
                        Button("OK", action: {
                            
                        })
                    }, message: {
                        Text("Invalide email (utiliser email esprit)")
                        
                    })
                    
                }
                // moving view down..
                .offset(y: 25)
                // hiding view when its in background...
                // only button...
                .opacity(self.index == 1 ? 1 : 0)
                
                
            }
            
            
        }
        func isEspritEmail(email : String) -> Bool {
            let domain = "@esprit.tn"
            return email.contains(domain)
        }
        
    }











struct ImagePicker: UIViewControllerRepresentable {
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
    

