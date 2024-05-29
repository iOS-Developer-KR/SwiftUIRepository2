//
//  ContentView.swift
//  AVFoundationTest
//
//  Created by Taewon Yoon on 5/29/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(AudioRecorder.self) var recorder
    
    var body: some View {
        VStack {
            Button(action: {
                recorder.recordAudio()
            }, label: {
                Text("Start Recording")
            })
            .padding(.bottom, 50)
            Button {
                recorder.stopRecordAudio()
            } label: {
                Text("Stop Recording")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
