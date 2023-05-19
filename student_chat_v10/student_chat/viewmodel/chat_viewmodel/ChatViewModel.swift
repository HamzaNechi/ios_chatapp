//
//  ChatViewModel.swift
//  Chat
//
//  Created by Mac Mini 3 on 15/4/2023.
//

import Foundation

class ChatsViewModel: ObservableObject {
    
    //@Published var chats = Chat.sampleChat
    @Published var chats : [ChatMessage] = []
    final var base_url: String = "http://172.17.1.113:9090"
    
    func getAllMessage(user_id:String, completion : @escaping ([ChatMessage])->()){
        print("fetch msg start")
        guard let url = URL(string: "\(self.base_url)/message/msg_user") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "user_id":user_id,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode get msgs: \(httpResponse.statusCode)")
                do{
                    let msgs = try JSONDecoder().decode([ChatMessage].self, from: data)
                    DispatchQueue.main.async {
                        completion(msgs)
                        self?.chats = msgs
                    }
                }
                catch{
                    print(error)
                }
            }
            //convert to json
            
            
            
        }
        
        task.resume()
    }
    
//    func getSortedFilteredChats(query:String)->[ChatMessage]{
//        let sortedChats = chats.sorted {
//            guard let date1 = $0.message.date else {return false}
//            guard let date2 = $1.message.date else {return false}
//            return date1 > date2
//
//
//        }
//        if query == ""{
//            return sortedChats
//        }
//        return sortedChats.filter{$0.person.name.lowercased().contains(query.lowercased())}
//
//    }
    
//    func markAsUnread(_ newValue: Bool, chat: Chat) {
//        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
//            chats[index].hasUnreadMessage = newValue
//        }
//    }
    
//    func sendMessage(_ text:String, in chat: Chat)-> Message? {
//        if let index = chats.firstIndex(where: {$0.id == chat.id }){
//            let message = Message(text, type: .Sent)
//            chats[index].messages.append(message)
//            return message
//        }
//        return nil
//
//    }
}
