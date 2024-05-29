//
//  ContentView.swift
//  SpeechTest
//
//  Created by Taewon Yoon on 5/28/24.
//

import SwiftUI
import Speech

struct ContentView: View {
    @Environment(ViewModel.self) var temp
    var body: some View {
        Button(action: {
            temp.startCaptureAudio()
        }, label: {
            Text("Button")
        })
    }
}

#Preview {
    ContentView()
        .environment(ViewModel())
}
