//
//  MessageRoomViewModel.swift
//  student_chat
//
//  Created by Mac Mini 2 on 6/5/2023.
//

import Foundation
import SocketIO


class MessageRoomViewModel: ObservableObject {
    
    @Published var chats = Chat.sampleChat
    @Published var rooms : [MessageRoom] = []
    final var base_url: String = "http://172.17.1.113:9090"

    
    func sendMessage(chat_id: String, user_id: String, content:String , completion : @escaping (MessageRoom)->()){
        print("send message start")
        guard let url = URL(string: "\(self.base_url)/message/send") else{
            print("Invalid url !")
            return
        }
        
        var request = URLRequest(url: url)
        //method , body , headers
        request.httpMethod="POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body : [String: AnyHashable] = [
            "chat_id":chat_id,
            "user_id":user_id,
            "content": content
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body , options: .fragmentsAllowed)
        
        //Make the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode send message: \(httpResponse.statusCode)")
                if(httpResponse.statusCode == 200 ){
                    //yelzem ywali yrajja3li eli zedou bl populate user
                    do{
                        
                        let msg = try JSONDecoder().decode(MessageRoom.self, from: data)
                        DispatchQueue.main.async {
                            completion(msg)
                        }
                    }
                    catch{
                        
                        print("error send message status \(httpResponse.statusCode)")
                        print(error)
                    }
                }
                
            }

        }
        task.resume()
    }
    
    
    func getAllMessage(room_id:String, completion: @escaping ([MessageRoom]) -> ()){
        print("fetch msg start")
        guard let url = URL(string: "\(self.base_url)/message/\(room_id)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data , response , error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                print("statusCode getComment: \(httpResponse.statusCode)")
                do{
                    let msg = try JSONDecoder().decode([MessageRoom].self, from: data)

                    DispatchQueue.main.async {
                        completion(msg)
                        self?.rooms = msg
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
    
    func markAsUnread(_ newValue: Bool, chat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == chat.id }) {
            chats[index].hasUnreadMessage = newValue
        }
    }
    
    func sendMessage(_ text:String, in chat: Chat)-> Message? {
        if let index = chats.firstIndex(where: {$0.id == chat.id }){
            let message = Message(text, type: .Sent)
            chats[index].messages.append(message)
            return message
        }
        return nil
        
    }
}
