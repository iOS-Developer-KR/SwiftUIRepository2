//
//  ContentView.swift
//  iOS-ChatGPT
//
//  Created by Taewon Yoon on 5/13/24.
//

import SwiftUI
import OpenAI

struct MainView: View {
    
    @EnvironmentObject var chat: ChatGPT
    @State private var textfield: String = ""
    @State private var newConversation: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ForEach(chat.conversations, id: \.id) { converstation in
                    NavigationLink(value: converstation) {
                        HStack {
                            Text(converstation.messages.first?.content ?? "대화 내용이 없습니다")
                            Spacer()
                        }
                    }
                    .padding()
                }
                Spacer()
            }
            .navigationTitle("채팅 목록")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: Conversation.self) { value in
                ConversationView(conversationId: value.id)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        
                        Spacer()
                        
                        Button(action: {
                            chat.createConversation()
                        }, label: {
                            Image(systemName: "plus.circle")
                        })
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MainView()
            .environmentObject(ChatGPT())
    }
}
