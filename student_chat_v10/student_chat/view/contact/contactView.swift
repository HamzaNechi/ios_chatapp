//
//  contactView.swift
//  student_chat
//
//  Created by Mac Mini 11 on 14/4/2023.
//

import SwiftUI

struct contactView: View {
    @State var index = 0
    var body: some View {
        NavigationView{
            VStack{
                appBar(index: self.$index)
                ZStack{
                    InvitationView().opacity(self.index == 0 ? 1 : 0)
                    
                    AmisView().opacity(self.index == 1 ? 1 : 0)
                }
            }.edgesIgnoringSafeArea(.top)
            
        }.navigationBarHidden(true)
        
        
        //end tabbar

        
    }
}

struct InvitationView: View{
    @State var invitations: [Invitation] = []
    private var viewModelInvi = InvitationViewModel()
    @State var idUser: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    var body : some View{
        NavigationView{
            ScrollView{
                
                ForEach(self.invitations, id: \.self) { item in
                    //item 1
                    HStack{
                        AsyncImage(url: URL(string: item.expediteur.image)){
                            image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 60,height: 60)
                                .cornerRadius(80)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                        
                        Text(item.expediteur.username)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Secondary"))
                        
                        
                        Spacer()
                        
                        Button(action: {
                            var usr : Invitation = item
                            viewModelInvi.acceptRequest(inv_id: item._id){
                                resp in
                                if(resp){
                                    self.invitations.removeAll(where: {$0._id == usr._id})
                                }
                                print("response accept invitation \(resp)")
                            }
                            
                        }, label: {
                            Image(systemName: "personalhotspot")
                                .resizable()
                                .frame(width: 21,height: 21)
                                .foregroundColor(.white)
                        }).buttonStyle(GrowingButton())
                        
                        Button(action: {
                            var usr : Invitation = item
                            viewModelInvi.refuseInvitation(inv_id: item._id){
                                res in
                                if(res){
                                    self.invitations.removeAll(where: {$0._id == usr._id})
                                }
                                print("response refuse invitation \(res)")
                            }
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 21,height: 21)
                                .foregroundColor(.white)
                        }).buttonStyle(GrowingButtonTrash())
                        
                    }.padding(10)
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height:4)
                        .foregroundColor(.gray)
                    
                    //end item 1
                }
                
                
            }
            
        }.background(Color(.blue))
            .onAppear{
                viewModelInvi.getAllUserInvi(user_id: idUser){
                    res in
                    self.invitations = res
                }
            }
        
    }
    
    
}

struct AmisView: View{
    private var amisController = AmisViewModel()
    @State var userId: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    @State var amis : [User] = []
    @State var showAlert : Bool = false
    @State var chat_id: String = ""
    @State var goChatView : Bool = false
    var body : some View{
        NavigationView{
            ScrollView{
                ForEach(self.amis, id: \.self) { item in
                    //item 1
                    HStack{
                        AsyncImage(url: URL(string: item.image)){
                            image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 60,height: 60)
                                .cornerRadius(80)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        
                        
                        Text(item.username)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Secondary"))
                        
                        if(item.status == "En ligne"){
                            Image(systemName: "checkmark")
                                .font(.system(size: 8,weight: .semibold))
                                .padding(2)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: ChatView(room_id : self.chat_id), isActive: self.$goChatView,label: {
                            
                        })
                        Button(action: {
                            amisController.getOrCreateRoom(current_user: userId, amis_user: item._id){
                                chat_id in
                                self.chat_id = chat_id
                                self.goChatView = true
                                print("youur chat room id = \(chat_id)")
                            }
                            
                        }, label: {
                            Image(systemName: "message")
                                .resizable()
                                .frame(width: 21,height: 21)
                                .foregroundColor(.white)
                        }).buttonStyle(GrowingButton())
                        
                        Button(action: {
                            self.showAlert = true
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 21,height: 21)
                                .foregroundColor(.white)
                        }).buttonStyle(GrowingButtonTrash())
                        
                    }.padding(10)
                        .alert(isPresented: self.$showAlert){
                            Alert(
                                title: Text("Actions"),
                                message: Text("Etes-vous sur de vouloir supprimer \(item.username)"),
                                primaryButton: .destructive(Text("Supprimer")){
                                    let usr : User = item
                                    amisController.deleteAmis(currentUser_id: self.userId, amis_id: item._id){
                                        res in
                                        if(res){
                                            self.amis.removeAll(where: {$0._id == usr._id})
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("Annuler")))
                        }
                    
                    Rectangle()
                        .frame(width: UIScreen.main.bounds.width, height:4)
                        .foregroundColor(.gray)
                    
                    //end item 1
                }
            }
            
            
        }.background(Color(.gray))
            .onAppear{
                amisController.getAllUserAmis(user_id: userId){
                    res in
                    self.amis = res
                }
            }
        
    }
    
    
}

struct appBar: View{
    @StateObject var viewModel = ProfileViewModel()
    @State private var _id: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    @Binding var index : Int
    var body : some View{
        VStack(spacing: 25){
            HStack{
                Text("Contacts")
                    .fontWeight(.bold)
                    .font(.title)
                    .foregroundColor(.white)
                
                Spacer(minLength: 0)
                
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
                }, label: {
                    //
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 18,height: 18)
                        .foregroundColor(.white)
                })
                
                
            }
            
            //end title
            
            
            HStack{
                Button(action: {
                    self.index = 0
                }, label: {
                    VStack{
                        Text("Invitations").foregroundColor(.white)
                            .fontWeight(self.index == 0 ? .semibold : .none)
                        
                        
                        Capsule().fill(self.index == 0 ? Color.white : Color.clear)
                            .frame(height: 4)
                    }
                })
                
                
                Button(action: {
                    self.index = 1
                }, label: {
                    VStack{
                        Text("Amis").foregroundColor(.white)
                            .fontWeight(self.index == 1 ? .semibold : .none)
                        
                        Capsule().fill(self.index == 1 ? Color.white : Color.clear)
                            .frame(height: 4)
                    }
                })
            }
            .padding(3)
        }.padding(.horizontal)
            .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top)! + 10)
            .background(Color("Color1"))
        
    }
    
    
}



// style button
struct GrowingButton: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 7)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


// style button
struct GrowingButtonTrash: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all, 7)
            .background(.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}


//struct contactView_Previews: PreviewProvider {
//    static var previews: some View {
//        contactView()
//    }
//}
