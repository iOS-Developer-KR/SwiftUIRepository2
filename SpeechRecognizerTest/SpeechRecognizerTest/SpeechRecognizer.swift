//
//  SpeechRecognizer.swift
//  SpeechRecognizerTest
//
//  Created by Taewon Yoon on 6/3/24.
//
import SwiftUI
import AVFoundation

class AudioRecorder: ObservableObject {
    private var audioEngine: AVAudioEngine!
    private var audioFile: AVAudioFile?
    private var audioRecorder: AVAudioRecorder?
    private var inputNode: AVAudioInputNode?
    private var recordingURL: URL!
    private var timer: Timer?
    var isRecording = false

    init() {
        setupAudio()
    }

    private func setupAudio() {
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        
        let recordingFormat = inputNode!.outputFormat(forBus: 0)
        audioEngine.inputNode.removeTap(onBus: 0)
        inputNode!.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, when in
            self.processAudio(buffer: buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("AudioEngine couldn't start: \(error.localizedDescription)")
        }
        
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("recording.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL, settings: settings)
            audioRecorder?.isMeteringEnabled = true
        } catch {
            print("AudioRecorder couldn't be created: \(error.localizedDescription)")
        }
    }
    
    private func processAudio(buffer: AVAudioPCMBuffer) {
        guard let channelData = buffer.floatChannelData?[0] else { return }
        let channelDataValueArray = stride(from: 0, to: Int(buffer.frameLength), by: buffer.stride).map { channelData[$0] }
        let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))

        let avgPower = 20 * log10(rms)
        DispatchQueue.main.async {
            if avgPower > -30 {
                if !self.isRecording {
                    self.startRecording()
                }
            } else {
                if self.isRecording {
                    self.stopRecording()
                }
            }
        }
    }
    
    private func startRecording() {
        audioRecorder?.record()
        isRecording = true
        print("Recording started")
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        print("Recording stopped")
    }
}
