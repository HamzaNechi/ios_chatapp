

import Foundation


struct Chat: Identifiable {
    var id : UUID{
        person.id
    }
    let person: Person
    var messages: [Message]
    var hasUnreadMessage = false
        
}

struct Person: Identifiable{
    let id = UUID()
    let name: String
    let imgString: String
}

struct Message: Identifiable {
    
    enum MessageType{
        case Sent, Received
    }
    let id = UUID()
    let date: Date
    let text: String
    let type: MessageType
    
    
    init (_ text: String, type: MessageType, date:Date){
        self.date = date
        self.type = type
        self.text = text
        
    }
    
    init(_ text: String,type: MessageType) {
        self.init(text, type: type,date:Date())
    }
}
extension Chat{
        static let sampleChat = [
            Chat(person: Person(name: "ghassen", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 5  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 4  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 3  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 2  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 1 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 1  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 1  )),
                Message("this joke is so old",type: .Received,date: Date()),
                
            ], hasUnreadMessage: true),
            Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),
            Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),
                Message("this joke is so old",type: .Received,date: Date()),

                
            ], hasUnreadMessage: true),  Chat(person: Person(name: "Andrej", imgString: "photo1"),messages: [
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 10  )),
                Message("how are ",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("you",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("sdfsdf",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9)),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9 )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 9  )),
                Message("hey ghassen",type: .Sent,date: Date(timeIntervalSinceNow: -86400 * 8  )),

                
            ], hasUnreadMessage: true),
        ]
    }
    

