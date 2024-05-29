//
//  AudioRecorder.swift
//  AVFoundationTest
//
//  Created by Taewon Yoon on 5/29/24.
//

import Foundation
import AVFoundation

@Observable
class AudioRecorder: NSObject {
    var recorder = AVAudioRecorder()
    var audioPlayer = AVAudioPlayer()
    var recordingSession = AVAudioSession.sharedInstance()

    var captureURL: URL {
        (FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("recording.m4a", conformingTo: .audio))!
    }
    
    override init() {
        super.init()
        do {
            try recordingSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            
            AVAudioApplication.requestRecordPermission { allowed in
                if !allowed {
                    print("Recording not allowed by the user" as! Error)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func recordAudio() {
        do {
            recorder = try AVAudioRecorder(url: captureURL, settings: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ])
            recorder.record()
            recorder.delegate = self
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func pauseRecordAudio() {
        recorder.pause()
    }
    
    func stopRecordAudio() {
        recorder.stop()
    }
    
    func deleteRecordAudio() {
        recorder.deleteRecording()
    }
    
    func playRecordAudio() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: captureURL)
            audioPlayer.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playRecordAudio()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: (any Error)?) {
        
    }
}
