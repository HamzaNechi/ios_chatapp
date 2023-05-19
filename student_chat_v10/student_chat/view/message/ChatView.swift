//
//  ChatView.swift
//  Chat
//
//  Created by Mac Mini 3 on 15/4/2023.
//

import SwiftUI
import SocketIO


struct ChatView: View {
    var room_id:String
    var viewModel = ChatsViewModel()
    var messageViewModel = MessageRoomViewModel()
    @State var messages : [MessageRoom] = []
    //let chat: Chat
    var userId: String = UserDefaults.standard.string(forKey: "id") ?? "nil"
    @State var text = ""
    //@FocusState private var isFocused
    
    @State private var messageIDToScroll:String?
    //socket
    var manager = SocketManager(socketURL: URL(string: "http://172.17.1.113:9090/")! ,config: [.log(true), .compress])
    
    
    var body: some View {
        VStack(spacing:0){
            GeometryReader{ reader in
                ScrollView {
                    ScrollViewReader{
                        scrollReader in
                        getMessagesView(viewWidth: reader.size.width)
                            .padding(.horizontal)
                            .onChange(of:self.messages) { value in
                                scrollTo(messageID: value[self.messages.count-1]._id,
                                             shouldAnimate: true, scrollReader: scrollReader)
                                
                            }
                            .onAppear{

                                messageViewModel.getAllMessage(room_id: self.room_id){
                                    messages in
                                    self.messages = messages
                                }
                                
                            }
                        
                    }
                }
                    
                }
            .padding(.bottom, 5)
                
                toolBarView()
            }
            .padding(.top, 1)
            .navigationBarTitleDisplayMode(.inline)
            
            .onAppear{
               // viewModel.markAsUnread(false, chat: chat)
                
            }
        }
        
        func scrollTo(messageID:String, anchor: UnitPoint? = nil, shouldAnimate: Bool, scrollReader: ScrollViewProxy) {
            DispatchQueue.main.async{
                withAnimation(shouldAnimate ? Animation.easeIn : nil){
                    scrollReader.scrollTo(messageID,anchor: anchor)
                }
                
            }
        }
        
        func toolBarView() -> some View {
            VStack {
                let height: CGFloat=37
                HStack{
                    TextField("Message ...", text: $text)
                        .padding(.horizontal, 10)
                        .frame(height: height)
                        .background(Color.gray.opacity(0.1))
                        .foregroundColor(Color("Secondary"))
                        .foregroundColor(Color("accentColor"))
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                        //.focused($isFocused)
                    
                    Button(action: sendMessage){
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .frame(width: height, height: height)
                            .background(
                                Circle()
                                    .foregroundColor(text.isEmpty ? .gray : .blue)
                            )
                    }
                    .disabled(text.isEmpty)
                }
                .frame(height: height)
                
            }
            .padding(.vertical)
            .padding(.horizontal)
            .background(.thickMaterial)
        }
        
        func sendMessage(){
            let currentuser = UserDefaults.standard.string(forKey: "id") ?? "nil"
            print("current user id \(currentuser)")
            print("chat id send message \(self.room_id)")
            print("chat text send message \(self.text)")
            messageViewModel.sendMessage(chat_id: self.room_id, user_id: currentuser, content: self.text){
                msg in
                if(!msg._id.isEmpty){
                    self.text=""
                }
                //socket start
                
                let socket = self.manager.defaultSocket
                socket.disconnect()
                socket.on(clientEvent: .connect){_,_ in
                    let data = self.convertToJson(msg: msg)
                    socket.emit("send_chat",data)
                    socket.on("receive_msg_send"){
                        data,ack in
                        if let jsonString = data.first as? String,
                           let jsonData = jsonString.data(using: .utf8),
                           let message = try? JSONDecoder().decode(MessageRoom.self, from: jsonData){
                            
                            self.messages.append(message)
                        }
                        
                        print("response socket chatview receive = \(data)")
                    }
                }
                socket.connect()
                //end socket
                
                }
        }
        
    func convertToJson(msg : MessageRoom) -> String {
        let jsonEncoder = JSONEncoder()
        guard let jsonData = try? jsonEncoder.encode(msg) else { return "" }
        let json = String(data: jsonData, encoding: String.Encoding.utf8)!
        return json
    }
    
    
    
        
        let columns = [  GridItem(.flexible(minimum: 10))]
        
        func getMessagesView(viewWidth: CGFloat) -> some View {
            let currentuser = UserDefaults.standard.string(forKey: "id") ?? "nil"
            return LazyVGrid(columns: columns, spacing: 0){
                ForEach(self.messages, id: \.self) { message in
                   // var isReceived = message.user_id._id == (UserDefaults.standard.string(forKey: "id") ?? "nil") ? true : false;
                    let isReceived = currentuser != message.user_id._id
                    
                    HStack{
                        ZStack{
                            Text(message.content)
                                .padding(.horizontal)
                                .padding(.vertical, 12)
                                .background(isReceived ? Color.black.opacity(0.2) : .green.opacity(0.9))
                                .cornerRadius(13)
                            
                        }
                        .frame(width: viewWidth * 0.7 , alignment: isReceived ? .leading : .trailing)
                        .padding(.vertical)
                        //                    .background(Color.blue)
                    }
                    .frame(maxWidth: .infinity, alignment: isReceived ? .leading : .trailing)
                    .id(message._id) // import for automatic scrollig later
                    
                }
            }
        }
    }
    
//    struct ChatView_Previews: PreviewProvider {
//        static var previews: some View {
//            ChatView(room_id: "", chat: Chat.sampleChat[0])
//                .environmentObject(ChatsViewModel())
//        }
//    }
    

