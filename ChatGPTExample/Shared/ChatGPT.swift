//
//  OpenAI.swift
//  iOS-ChatGPT
//
//  Created by Taewon Yoon on 5/14/24.
//

import Foundation
import OpenAI
import SwiftUI



public final class ChatGPT: ObservableObject {
    let openAIClient = OpenAI(apiToken: "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")


    @Published var conversations: [Conversation] = []
    @Published var conversationErrors: [Conversation.ID: Error] = [:]
    @Published var selectedConversationID: Conversation.ID?

    var selectedConversation: Conversation? {
        selectedConversationID.flatMap { id in
            conversations.first { $0.id == id }
        }
    }

    init(selectedConversationID: Conversation.ID? = nil) {
        self.selectedConversationID = selectedConversationID
    }

    // MARK: - Events
    func createConversation() {
        let conversation = Conversation(id: UUID().uuidString, messages: [])
        conversations.append(conversation)
    }
    
    func selectConversation(_ conversationId: Conversation.ID?) {
        selectedConversationID = conversationId
    }
    
    func deleteConversation(_ conversationId: Conversation.ID) {
        conversations.removeAll(where: { $0.id == conversationId })
    }
    
    @MainActor
    func sendMessage(
        _ message: Message,
        conversationId: Conversation.ID,
        model: Model
    ) async {
        guard let conversationIndex = conversations.firstIndex(where: { $0.id == conversationId }) else {
            print("채팅방의 아이디가 존재하지 않는다")
            return
        }
        conversations[conversationIndex].messages.append(message)

        await completeChat(conversationId: conversationId, model: model)
    }
    
    
    @MainActor
    func completeChat(conversationId: Conversation.ID, model: Model) async {
        guard let conversation = conversations.first(where: { $0.id == conversationId }) else { // 만약 conversationId 대화의 아이디가 존재하는 채팅방들의 id에서 존재하지 않는다면 return
            return
        }
                
        conversationErrors[conversationId] = nil // 문제가 없으면 에러를 nil로 표기

        do {
            guard let conversationIndex = conversations.firstIndex(where: { $0.id == conversationId }) else { // 마지막의 채팅 index 가져오기
                return
            }
            
            let chatsStream: AsyncThrowingStream<ChatStreamResult, Error> = openAIClient.chatsStream(
                query: ChatQuery(
                    messages: conversation.messages.map { message in
                        ChatQuery.ChatCompletionMessageParam(role: message.role, content: message.content)!
                    }, model: model
                )
            )

            for try await partialChatResult in chatsStream {
                for choice in partialChatResult.choices { // 대화 내용(content)을 담고 있는 choices
                    let existingMessages = conversations[conversationIndex].messages

                    let messageText = choice.delta.content ?? ""

                    let message = Message(
                        id: partialChatResult.id,
                        role: choice.delta.role ?? .assistant,
                        content: messageText,
                        createdAt: Date(timeIntervalSince1970: TimeInterval(partialChatResult.created))
                    )
                    if let existingMessageIndex = existingMessages.firstIndex(where: { $0.id == partialChatResult.id }) { // 메시지의 id가 이전거랑 같다면 덮어 씌우기
                        // Meld into previous message
                        let previousMessage = existingMessages[existingMessageIndex]
                        let combinedMessage = Message( // GPT로부터 받은 메시지를 Message로 구조체에 맞춰서 인스턴스 생성
                            id: message.id, // id stays the same for different deltas
                            role: message.role,
                            content: previousMessage.content + message.content,
                            createdAt: message.createdAt
                        )
                        conversations[conversationIndex].messages[existingMessageIndex] = combinedMessage
                    } else {
                        conversations[conversationIndex].messages.append(message) // 같은 메시지 id가 아니라면 새로 추가하기
                    }
                }
            }
        } catch {
            conversationErrors[conversationId] = error
        }
    }
}
