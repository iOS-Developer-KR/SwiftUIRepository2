//
//  SpeechTestApp.swift
//  SpeechTest
//
//  Created by Taewon Yoon on 5/28/24.
//

import SwiftUI

@main
struct SpeechTestApp: App {
    @State var temp = ViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(temp)
        }
    }
}
