//
//  SocketHandler.swift
//  student_chat
//
//  Created by Mac Mini 2 on 6/5/2023.
//

import Foundation
import SocketIO

final class SocketHandler: ObservableObject{
    private var manager = SocketManager(socketURL: URL(string: "http://172.17.1.48:9090/")! ,config: [.log(true), .compress])
    
    init() {
        let socket = manager.defaultSocket
        socket.on(clientEvent: .connect){(data, ack) in
            print("Socket Connected.")
            socket.emit("send_chat","Hi nodejs server")
        }
    }
}
