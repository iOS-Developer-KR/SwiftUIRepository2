//
//  AVFoundationTestApp.swift
//  AVFoundationTest
//
//  Created by Taewon Yoon on 5/29/24.
//

import SwiftUI

@main
struct AVFoundationTestApp: App {
    @State var recorder = AudioRecorder()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recorder)
        }
    }
}
