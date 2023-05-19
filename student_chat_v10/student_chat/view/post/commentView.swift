//
//  commentView.swift
//  student_chat
//
//  Created by Mac Mini 5 on 1/5/2023.
//

import SwiftUI


struct itemComment: View{
    var comment: Comment
    @State var showAlert : Bool = false
    var commentViewModel = CommentViewModel()
    var body: some View{
        HStack (spacing: 20){
            AsyncImage(url: URL(string: self.comment.user.image)){
                image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: 40,height: 40)
            .clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading,spacing:5) {
                    HStack{
                        Text(self.comment.user.username)
                            .bold()
                        
                    }
                    HStack{
                        Text(self.comment.content)
                            .foregroundColor(.gray)
                            .frame(alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                    
                }
            }
            
        }
        .padding(.horizontal)
        .onLongPressGesture {
            self.showAlert = true
            
        }.alert(isPresented: self.$showAlert){
            Alert(
                title: Text("Confirm Deletion"),
                message: Text("Are you sure ?"),
                primaryButton: .destructive(Text("Delete")){
                    commentViewModel.deleteComment(comment_id: self.comment._id){
                        res in
                        print(res)
                    }
                },
                secondaryButton: .cancel())
        }
    
    }
}

struct commentView: View {
    @State var comments: [Comment]
    var post_id: String
    var commentViewModel = CommentViewModel()
    
    
    @State var comment:String = ""
    

    
    var body: some View {
        NavigationView{
            VStack{
                
                
                
                ScrollView{
                    ForEach(self.comments, id: \.self) { item in
                        itemComment(comment: item)
                    }
                }
                
                HStack{
                    TextField("add your comment here...",text: $comment)
                  //  FirstResponderTextField(text: $no)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Button(action: {
                        commentViewModel.addComment(post_id: self.post_id, content: self.comment){
                            res in
                            if(res){
                                commentViewModel.getComments(post_id: self.post_id){
                                    resp in
                                    self.comments = resp
                                    self.comment = ""
                                }
                            }
                        }
                    }, label: {
                        Image(systemName: "envelope.badge.shield.leadinghalf.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .padding(.horizontal, 10)
                    })
                    
                    
                }.padding(15)
            }
        }
    }
}

//struct commentView_Previews: PreviewProvider {
//    static var previews: some View {
//        commentView()
//    }
//}
