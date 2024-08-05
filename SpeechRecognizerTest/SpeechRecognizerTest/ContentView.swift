//
//  ContentView.swift
//  SpeechRecognizerTest
//
//  Created by Taewon Yoon on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var audioRecorder = AudioRecorder()
    
    var body: some View {
        VStack {
            Text("Audio Recorder")
                .font(.largeTitle)
            
            if audioRecorder.isRecording {
                Text("Recording...")
                    .foregroundColor(.red)
            } else {
                Text("Not Recording")
                    .foregroundColor(.green)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
