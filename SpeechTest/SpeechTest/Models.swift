//
//  VoidType.swift
//  SpeechTest
//
//  Created by Taewon Yoon on 5/28/24.
//

import Foundation

enum VoidType: String, Codable, Hashable, Sendable, CaseIterable {
    case alloy
    case echo
    case fable
    case onyx
    case nova
    case shimmer
}

enum VoiceChatState {
    case idle
    case recordingSpeech
    case processingSpeech
    case playingSpeech
    case error(Error)
}
