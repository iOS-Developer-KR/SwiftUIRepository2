//
//  Conversation.swift
//  iOS-ChatGPT
//
//  Created by Taewon Yoon on 5/14/24.
//

import Foundation
import OpenAI

struct Conversation: Hashable {
    init(id: String, messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }
    
    typealias ID = String
    
    let id: String
    var messages: [Message]
}

extension Conversation: Equatable, Identifiable {}
