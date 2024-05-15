//
//  iOS_ChatGPTApp.swift
//  iOS-ChatGPT
//
//  Created by Taewon Yoon on 5/13/24.
//

import SwiftUI

@main
struct iOS_ChatGPTApp: App {
    @State var chatgpt = ChatGPT()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .environmentObject(chatgpt)
    }
}
