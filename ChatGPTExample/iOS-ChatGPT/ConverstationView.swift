//
//  ConverstationView.swift
//  iOS-ChatGPT
//
//  Created by Taewon Yoon on 5/14/24.
//

import SwiftUI

struct ConversationView: View {
    
    @EnvironmentObject var chat: ChatGPT
    @State private var textfield: String = ""
    @State var conversationId: String
    
    var body: some View {
        Text("")
        VStack {
            ScrollView {
                VStack {
                    if let messages = chat.selectedConversation?.messages {
                        ForEach(messages) { message in
                            HStack {
                                VStack {
                                    Image(systemName: message.role == .assistant ? "desktopcomputer" : "person")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    Text(message.role == .assistant ? "GPT" : "나")

                                    Spacer()
                                }

                                Text(message.content)
                                    .textFieldStyle(.roundedBorder)
                                    .background(Color.gray.opacity(0.1))
                                
                                Spacer()
                            }
                        }
                    }
                    Spacer()
                }
            }.padding()
            
            Spacer()
            
            HStack {
                TextField("질문하기...", text: $textfield)
                    .textFieldStyle(.roundedBorder)
                    .border(Color.gray, width: 0.5)
                Button {
                    Task {
                        let message = Message(id: UUID().uuidString, role: .user, content: textfield, createdAt: Date())
                        await chat.sendMessage(message, conversationId: conversationId, model: .gpt4)
                        textfield = ""
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .font(.title)
                        .rotationEffect(Angle(degrees: 45))
                }.buttonStyle(.borderless)
                    .tint(.blue)
            }
            .padding()
        }
        .onAppear {
            chat.selectedConversationID = conversationId
        }
        
    }
}

#Preview {
    ConversationView(conversationId: "test")
        .environmentObject(ChatGPT())
    
    
}
