//
//  ChatRow.swift
//  Chat
//
//  Created by Mac Mini 3 on 15/4/2023.
//

import SwiftUI

struct ChatRow: View {
    
    let chat: ChatMessage
    
    func computeNewDate(from fromDate: String, to toDate: Date) -> Date{
        //convert string to dat
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:fromDate)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        let finalDate = calendar.date(from:components)
        //end convert
        let delta = toDate - finalDate! // `Date` - `Date` = `TimeInterval`
         let today = Date()
         if delta < 0 {
             return today
         } else {
             return today + delta // `Date` + `TimeInterval` = `Date`
         }
    }
    
    var body: some View {
        
         // set locale to reliable US_POSIX
        
        
        
        HStack (spacing: 20){
            //use async image
            AsyncImage(url: URL(string: self.chat.user.image)){
                image in
                image.resizable()
            } placeholder: {
                ProgressView()
            }.frame(width: 70,height: 70)
            .clipShape(Circle())
            
            ZStack {
                VStack(alignment: .leading,spacing:5) {
                    HStack{
                        Text(chat.user.username)
                            .bold()
                        
                        Spacer()
                        Text(chat.message[0].date)//.descriptiveString() ?? "")
                        
                    }
                    HStack{
                        Text(chat.message[0].content)
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .frame(height: 50, alignment: .top)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.trailing, 40)
                    }
                    
                }
                
//                Circle().foregroundColor(chat.hasUnreadMessage ? .blue : .clear)
//                    .frame(width: 18,height: 18)
//                    .frame(maxWidth: .infinity,alignment: .trailing)
            }
            
        }
        .frame(height: 80)
    }
}

extension Date {

    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }

}

//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chat: Chat.sampleChat[1])
//    }
//}
