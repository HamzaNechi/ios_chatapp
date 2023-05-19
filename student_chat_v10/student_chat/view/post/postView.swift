//
//  postView.swift
//  student_chat
//
//  Created by Mac Mini 11 on 14/4/2023.
//

import SwiftUI

let primary = Color("AccentColor")
let secondry = Color ("Color")
let ternary = Color( #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
let lightGray = Color("Secondary")
struct postView: View {
    @State var viewModel=PostVM()
    @State  var posts: [PostModel] = []
    var counter = 0
    
    @State var isNewPost: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack{
                primary.edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView(showsIndicators: false){
                        Header()
                        CreatePost()
                        Dividers()
                        ForEach(self.posts, id: \.self) { item in
                            PostFeed(posts: self.$posts, post: item)
                        }
                        
                    }
                    Spacer()

                    Menu()
                }
                .foregroundColor(.white)
            }

        }.navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .onAppear{
                viewModel.fetch{ resp in
                self.posts = resp
                }
            }
            
        
    }
}

//struct postView_Previews: PreviewProvider {
//    static var previews: some View {
//        postView()
//    }
//}
struct Header: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var _id: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    var body: some View {
        HStack {
           // image
            Text("Accueil").font(.title).bold().foregroundColor(lightGray)

            Spacer()
            
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
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 18))
                    .padding(8)
                    .background(secondry)
                    .clipShape(Circle())
            }
            
            
        }
        .padding(.horizontal)
    }
    }

struct CreatePost: View{
    @State var showAlert : Bool = false
    @State var showAddPost : Bool = false
    
    //image user connected
    let userConnecting_image : String = UserDefaults.standard.string(forKey: "image") ?? "nil"
    let userConnecting_name : String = UserDefaults.standard.string(forKey: "username") ?? ":)"
    var body: some View{
        VStack{
            HStack{
                
                
                AsyncImage(url: URL(string: self.userConnecting_image)){
                    image in
                    image.resizable()
                } placeholder: {
                    Image("logo").resizable().frame(width: 50,height: 50).clipShape(Circle())
                }.frame(width: 50,height: 50)
                .clipShape(Circle())
                
                Text("Salut , \(self.userConnecting_name)")
                    .foregroundColor(Color("Secondary"))
                
                Spacer()
            }
            .padding(.horizontal)
            Rectangle()
                .frame(width: UIScreen.main.bounds.width, height:1 )
                .foregroundColor(secondry)
          
        }
        HStack{
            Spacer()
//            HStack{
//                Image(systemName: "video.fill")
//                    .foregroundColor(.red)
//                Text("Live")
//
//            }
            Spacer()
            Rectangle()
                .frame(width: 1,height: 20)
                .foregroundColor(secondry)
            Spacer()
            
            NavigationLink(destination: addPost(), isActive: self.$showAddPost,label: {
                
            })
            
            HStack{
                Button(action: {
                    self.showAddPost = true
                }, label: {
                    Image(systemName: "plus.square")
                        .resizable()
                        .frame(width: 20,height: 20)
                        .foregroundColor(Color("Color1"))
                    Text("Ajouter un post")
                        .foregroundColor(Color("Secondary"))
                })
                
                
            }
            Spacer()
            Rectangle()
                .frame(width: 1,height: 20)
                .foregroundColor(secondry)
            Spacer()
            Group {
//                HStack{
//                    Image(systemName: "video.fill")
//                        .foregroundColor(.red)
//                    Text("Room")
//                }
                Spacer()

            }
            
                
            }
        .font(.system(size: 14,weight: .semibold))
        }
    }

struct Dividers: View {
    var body: some View {
        Rectangle()
            .frame(width: UIScreen.main.bounds.width, height:6)
            .foregroundColor(ternary)
    }
}

struct MyStoryCard: View {
    var body: some View {
        ZStack(alignment: .top){
            RoundedRectangle(cornerRadius:15)
                .frame(width: 100,height: 170)
                .foregroundColor(secondry)
            ZStack(alignment: .bottom){
                Image("photo2")
                    .resizable()
                    .frame(width: 100, height: 110)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                VStack(spacing: 0){
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Color.red)
                        .clipShape(Circle())
                        .font(.system(size: 20, weight: .bold))
                        .overlay(Circle().stroke(secondry,lineWidth: 3))
                    
                    Group{
                        Text("create")
                        Text("story")
                    }
                    .font(.system(size:12,weight: .semibold))
                }
                .offset(y:45)
                
            }
        }
    }
}

struct Post: View{
    //list post
    @Binding var posts: [PostModel]
    
    
    var post: PostModel
    @State var viewModel=PostVM()
    @State var auteur:String = "hh"
    @State var isPartager: Bool = false
    
    //like variable
    @State var vModelLike=LikeViewModel()
    @State var likes : [Like] = []
    @State var isLike : Bool = false
    //end like
    
    //connecting user
    let userConnecting_id : String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    
    
    @State var showAlert: Bool = false
    //comment
    @State var commentViewModel = CommentViewModel()
    @State var comments : [Comment] = []
    @State var goComment: Bool = false
    
    //animation
    @State var isDetailExpanded = false
    @Namespace private var profileAnimation
    @Namespace private var profileEmail
    @Namespace private var profileClasse
    @Namespace private var profileFiliere
    @Namespace private var profileButton
    @State var invitationViewModel = InvitationViewModel()
    
    
    //alert invitation
    @State var showAlertInv: Bool = false
    @State var titleAlertInv : String = "Invitation"
    @State var messageAlertInv : String = "Invitation envoyer avec succés"
    
    //detail view
        var UserDetail: some View {
            
            //yets
            VStack{
                AsyncImage(url: URL(string: self.post.user.image)){
                    image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(width: 90,height: 90)
                .clipShape(Circle())
                .onTapGesture {
                     withAnimation(.spring()){
                            isDetailExpanded.toggle()
                        }
                  }
                  .matchedGeometryEffect(id: "Image", in: profileAnimation)
                
                VStack(alignment: .center){
                    Text(self.post.user.username).foregroundColor(lightGray).font(.title).bold()
                        .matchedGeometryEffect(id: "Name", in: profileAnimation)
                    Text(self.post.user.email).foregroundColor(lightGray).fontWeight(Font.Weight.semibold)
                        .matchedGeometryEffect(id: profileEmail, in: profileAnimation)
                    Text("classe : \(self.post.user.Classe)").foregroundColor(lightGray).fontWeight(Font.Weight.semibold)
                        .matchedGeometryEffect(id: profileClasse, in: profileAnimation)
                    Text("filiére : \(self.post.user.Filiere)").foregroundColor(lightGray).fontWeight(Font.Weight.semibold)
                        .matchedGeometryEffect(id: profileFiliere, in: profileAnimation)
                    Button(action: {
                        if(self.post.user._id != self.userConnecting_id){
                            invitationViewModel.sendInvitation(destinataire: self.post.user._id, expediteur: self.userConnecting_id){
                                inv in
                                if(inv){
                                    print("Invitation sended")
                                    
                                    self.showAlertInv = true
                                    self.titleAlertInv="Invitation"
                                    self.messageAlertInv="Invitation envoyer avec succés"
                                }
                            }
                        }else{
                            self.showAlertInv = true
                            self.titleAlertInv="Invitation"
                            self.messageAlertInv="Tu ne peut pas envoyer invitation à vous !!"
                        }
                        
                    }, label: {
                        HStack{
                            Text("Envoyer invitation").foregroundColor(.white).bold().padding()
                                
                        }
                        .frame(width: 200,height: 50)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    })
                    .matchedGeometryEffect(id: profileButton, in: profileAnimation)
                    .alert(isPresented: self.$showAlertInv){
                        Alert(
                            title: Text(self.titleAlertInv),
                            message: Text(self.messageAlertInv)
                        )
                    }
                }.padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16).stroke(Color("Secondary"), lineWidth: 2)
                    )
                
            }
            //yetfassa
        }
        
        
        //user profile view
        var UserView: some View {
            
            HStack{
                AsyncImage(url: URL(string: self.post.user.image)){
                    image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.frame(width: 40,height: 40)
                .clipShape(Circle())
                .onTapGesture {
                     withAnimation(.spring()){
                         isDetailExpanded.toggle()
                    }
                 }
                 .matchedGeometryEffect(id: "Image", in: profileAnimation)

                
                VStack(alignment: .leading, spacing: 0){
                    //start profile simple
                    HStack{
                        Text(self.post.user.username)
                            .foregroundColor(Color("Secondary"))
                            .font(.system(size: 14,weight: .semibold))
                        
                        if(self.post.user.status == "En ligne"){
                            Image(systemName: "checkmark")
                                .font(.system(size: 8,weight: .semibold))
                                .padding(2)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        if(self.isPartager){
                            Text("auteur")
                                .foregroundColor(.gray)
                                .font(.system(size: 14,weight: .semibold))
                            
                            Spacer()
                            
                            Text(self.auteur)
                                .foregroundColor(Color("Secondary"))
                                .font(.system(size: 14,weight: .semibold))
                        }
                        
                        
                        if(self.post.user._id == self.userConnecting_id){
                            Spacer()
                            
                           
                            
                            Button(action: {
                                self.showAlert = true
                            }, label: {
                                Image(systemName: "arrowtriangle.down.fill")
                                    .foregroundColor(Color("Secondary"))
                            })
                        }
                    }
                    HStack(spacing: 5){
                        Text("1 d")
                        Circle()
                            .frame(width: 2, height: 2)
                        Image(systemName: "globe")
                    }
                    .font(.system(size:12))
                    .foregroundColor(lightGray)
                    
                }.alert(isPresented: self.$showAlert){
                    Alert(
                        title: Text("Actions"),
                        message: Text("Delete or modif your post ..."),
                        primaryButton: .destructive(Text("Delete")){
                            var postToDelete = self.post
                            viewModel.deletePost(post_id: self.post._id){
                                res in
                                if(res){
                                    print("delete \(res) donc il faut faire refresh list")
                                    self.posts.remove(at: self.posts.firstIndex(of: postToDelete)!)
                                }
                            }
                        },
                        secondaryButton: .cancel(Text("Modifier")){
                            print("modifier")
                        })
                }
                .matchedGeometryEffect(id: "Name", in: profileAnimation)
                Spacer()
                
                Image(systemName: "Ghassen dhif")
                    .foregroundColor(lightGray)
                
            }
            .padding(.horizontal)
        }
    
    
    //main view
    
    var body: some View {
        
        VStack{
            if isDetailExpanded {
                UserDetail
            }else{
                UserView
            }
            Text(self.post.description)
                .padding(.horizontal)
                .font(.system(size: 14))
                .foregroundColor(Color("Secondary"))
            
            if(self.post.image != "empty"){
                AsyncImage(url: URL(string: self.post.image)){
                    image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }.scaledToFit()
            }
            
//            Image("photo2")
//                .resizable()
//                .scaledToFit()
            HStack{
                HStack(spacing: 3){
                    Image ("icons")
                        .resizable()
                        .frame(width: 15,height: 18)
                    Text("\(self.likes.count) Likes")
                }
                Spacer()
                HStack{
                    Text("\(self.comments.count) comments")
                    
                    
                }
            }
            .foregroundColor(lightGray)
            .font(.system(size:12))
            .padding(.horizontal)
            
            Rectangle()
                .frame(width: UIScreen.main.bounds.width - 15,height: 0.3)
            HStack{
                HStack{
                    
                    //check if list likes contains like th id post and id user connected
                    if(isLike){
                        
                        
                        Button(action: {
                            print("dislike")
                            vModelLike.deleteLike(post_id: self.post._id, user_id: self.userConnecting_id){
                                resp in
                                isLike = !resp
                                vModelLike.getAllPostLikes(post_id: self.post._id){
                                    resp in
                                    self.likes = resp
                                }
                            }
                            
                        },
                               label: {
                            Image(systemName: "hand.thumbsup.circle.fill")
                            Text("Like")
                        })
                    }else{
                        Button(action: {
                            print("like")
                            vModelLike.addLike(post_id: self.post._id, user_id: self.userConnecting_id){
                                res in
                                isLike = res
                                vModelLike.getAllPostLikes(post_id: self.post._id){
                                    resp in
                                    self.likes = resp
                                }
                            }
                        },
                               label: {
                            Image(systemName: "hand.thumbsup")
                            Text("Like")
                        })
                        
                    }
                    
                }
                
                Spacer()
                
                HStack{
                    NavigationLink(destination: commentView(comments: self.comments, post_id: self.post._id),isActive: self.$goComment){
                        
                    }
                    
                    Button(action: {
                        self.goComment = true
                    }, label: {
                        Image(systemName: "message")
                        Text("Comments")
                    })
                    
                }
                
                Spacer()
                
                HStack{
                    Button(action: {
                        viewModel.sharePost(post_id: self.post._id, user_id: self.userConnecting_id){
                            res in
                            print("share post \(res)")
                        }
                    }, label: {
                        Image(systemName: "arrowshape.turn.up.right")
                        Text("share")
                    })
                    
                }
            }
                .foregroundColor(lightGray)
                .font(.system(size: 14))
                .padding(  .horizontal)
                
                
        }.onAppear{
            //get author
            if(self.post.user._id != self.post.author){
                viewModel.getAuthor(author_id: self.post.author){
                    res in
                    self.auteur = res
                    self.isPartager = true
                }
                
            }
            
            //get all likes post
            vModelLike.getAllPostLikes(post_id: self.post._id){
                resp in
                self.likes = resp
            }
            
            
            //get if this user connecting like this post
            vModelLike.isUserLikePost(post_id: self.post._id, user_id: self.userConnecting_id){
                res in
                self.isLike = res
            }
            
            //getAllComments
            commentViewModel.getComments(post_id: self.post._id){
                ret in
                self.comments = ret
            }
        }
        
        }
    }

struct PostFeed : View{
    @Binding var posts: [PostModel]
    var post: PostModel
        var body: some View {
            //
            Post(posts: $posts, post: post)
            Dividers()

        }
}
 
struct Menu :View {
    var body: some View {
        HStack(spacing: 45){
            
            

        }
    }
}


