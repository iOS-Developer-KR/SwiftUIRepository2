//
//  ContentView.swift
//  SocketPratice
//
//  Created by Taewon Yoon on 11/11/24.
//

import SwiftUI
import Network

struct ContentView: View {
    
    @Environment(WebSocket.self) var socket
    
    var body: some View {
        NavigationStack {
            @Bindable var bindableSocket = socket
            TextField("사용하실 아이디를 입력해주세요", text: $bindableSocket.id)
                .multilineTextAlignment(.center)
                .padding()

            NavigationLink {
                ChatRoomView()
            } label: {
                Text("채팅방 입장하기")
            }

        }
    }
}

#Preview {
    ContentView()
        .environment(WebSocket())
}
