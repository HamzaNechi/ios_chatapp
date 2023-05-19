//
//  addPost.swift
//  student_chat
//
//  Created by Mac Mini 5 on 2/5/2023.
//

import SwiftUI

struct addPost: View {
    @State var content: String = "text..."
    //image
    @State var shouldShowImagePicker = false
    @State var image:UIImage?
    @State var viewModel = PostVM()
    //connecting user
    let userConnecting_id : String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    
    
    @State var goHome : Bool = false
    
    var body: some View {
        VStack{
            Spacer()
            
            Button(action: {
                print("pick image")
                shouldShowImagePicker.toggle()
            }, label: {
                if let image = self.image {
                    
                    VStack{
                        Text("Update image")
                            .foregroundColor(Color("Secondary"))
                        
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250,height: 250, alignment: .top)
                        
                        
                    }
                    
                 }else{
                     VStack{
                         Text("Choose image")
                             .foregroundColor(Color("Secondary"))
                         
                         Image("upl")
                             .resizable()
                             .frame(width: 250,height: 250, alignment: .top)
                         
                         
                     }
                     
                     
                 }
                
            }).sheet(isPresented: $shouldShowImagePicker, onDismiss: nil) {
                ImagePicker(image: $image)
                   // .ignoresSafeArea()
            }
            
            Spacer()
            
            VStack{
                HStack{
                    Text("add your text here")
                        .foregroundColor(Color("Secondary"))
                    
                    Spacer()
                }
                
                TextEditor(text: $content)
                    .padding(2)
                    .background(Color("Secondary"))
                    .clipShape(RoundedRectangle(cornerRadius: 0))
                    .frame(height: 180)
                    .onTapGesture {
                        if(self.content == "text..."){
                            self.content=""
                        }
                    }
            }.padding(.top, 15)
            
            Spacer()
            
            NavigationLink(destination: homeView(), isActive: self.$goHome,label: {
                
            })
            
            Button(action: {
                
                
                
                if let image = self.image {
                    viewModel.addPost(content: self.content, user_id: self.userConnecting_id, img: self.image!){
                        res in
                        print("add post response \(res)")
                        //self.goHome = true
                        DispatchQueue.main.async {
                            let mySwiftUIIViewhome = homeView()
                            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIViewhome)
                        }
                    }
                 }else{
                     viewModel.addPostSansImage(content: self.content, user_id: self.userConnecting_id){
                         resp in
                         print("add post sans image response \(resp)")
                         //self.goHome = true
                         DispatchQueue.main.async {
                             let mySwiftUIIViewhome = homeView()
                             UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: mySwiftUIIViewhome)
                         }
                     }
                     
                 }
            }){
                Text("Ajouter").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                
            }
            .foregroundColor(Color("Secondary"))
            .foregroundColor(Color("accentColor"))
            .background(Color("Color1"))
            .cornerRadius(10)
            
            
        }.padding()
        
            
    }
}


struct ImagePickerPost : UIViewControllerRepresentable{
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    
    @Binding var image: UIImage?
    
    let ctr = UIImagePickerController()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent : self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        
        let parent : ImagePickerPost
        
        init(parent: ImagePickerPost) {
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

struct addPost_Previews: PreviewProvider {
    static var previews: some View {
        addPost()
    }
}
