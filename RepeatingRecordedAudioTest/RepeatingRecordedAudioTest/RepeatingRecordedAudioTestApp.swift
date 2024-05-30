//
//  RepeatingRecordedAudioTestApp.swift
//  RepeatingRecordedAudioTest
//
//  Created by Taewon Yoon on 5/30/24.
//

import SwiftUI

@main
struct RepeatingRecordedAudioTestApp: App {
    @State var recorder = AudioRecorder()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recorder)
        }
    }
}
