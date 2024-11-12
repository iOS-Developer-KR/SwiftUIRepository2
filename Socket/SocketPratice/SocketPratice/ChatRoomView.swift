//
//  ChatRoomView.swift
//  SocketPratice
//
//  Created by Taewon Yoon on 11/12/24.
//

import SwiftUI

struct ChatRoomView: View {
    @Environment(WebSocket.self) var webSocket
    @State private var text: String = ""
    
    var body: some View {
        
        VStack {
            ForEach(webSocket.chats, id: \.id) { chat in
                VStack {
                    if(chat.sender == webSocket.id){
                        Spacer()
                    }
                    
                    HStack {
                        Text(chat.sender)
                        Spacer()
                    }
                    
                    HStack {
                        Text(chat.text)
                        Spacer()
                    }
                    
                    if(chat.sender != webSocket.id){
                        Spacer()
                    }
                }
                .padding()
            }
            
            
            Spacer()
            
            HStack {
                TextField("전송할 메시지 입력", text: $text)
                    .padding()
                
                Button {
                    webSocket.sendMessage(text)
                    text = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                }
                .padding()
            }
        }
        .onAppear {
            webSocket.connect()
        }
    }
}

#Preview {
    ChatRoomView()
        .environment(WebSocket())
}
