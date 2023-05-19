//
//  messageView.swift
//  student_chat
//
//  Created by Mac Mini 11 on 14/4/2023.
//

import SwiftUI

struct messageView: View {
    
    @StateObject var viewModel = ChatsViewModel()
    
    @State private var query = ""
    
    //connecting user
    let userConnecting_id : String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    
    @State var chats : [ChatMessage] = []
    var body: some View {
        
        NavigationView{
            //viewModel.getSortedFilteredChats(query: query)
            List {
                ForEach(self.chats
                        , id: \.self) { chat in
                    
                    ZStack{
                        ChatRow(chat: chat)
                        NavigationLink(destination: {
                            ChatView(room_id: chat.chat._id)
                                .environmentObject(viewModel)
                        }){
                            EmptyView()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .frame(width: 0)
                        .opacity(0)
                    }
                    
                    .swipeActions(edge: .leading, allowsFullSwipe: true){
                        Button(action: {
//                            viewModel.markAsUnread(!chat.hasUnreadMessage, chat: chat)
                        }){
//                            if chat.hasUnreadMessage {
//                                Label("Read", systemImage: "text.bubble")
//                            }else{
//                                Label("Unread", systemImage: "circle.fill")
//
//                            }
                        }
                        .tint(.blue)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .searchable(text: $query)
            .navigationTitle("chats")
//            .navigationBarItems(trailing: Button(action:{}){
//                Image(systemName: "square.and.pencil")
//            })
            .onAppear{
                viewModel.getAllMessage(user_id: self.userConnecting_id){
                    data in
                    self.chats = data
                }
            }
        }
    }
}

struct messageView_Previews: PreviewProvider {
    static var previews: some View {
        messageView()
    }
}
