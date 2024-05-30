//
//  AudioRecorder.swift
//  RepeatingRecordedAudioTest
//
//  Created by Taewon Yoon on 5/30/24.

import Foundation
import AVFoundation

@Observable
class AudioRecorder: NSObject {
    var recorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordingSession = AVAudioSession.sharedInstance()
    var animationTimer: Timer?
    var recordingTimer: Timer? // 유저가 말을 멈췄을 때를 위해 사용
    var audioPower = 0.0
    var prevAudioPower: Double?

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
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.record()
            
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self] _ in
                guard self.recorder != nil else { return }
                self.recorder.updateMeters()
                // power: 현재 음량에 대한 크기 조절 // 보통 averagePower는
                let power = max(0, 1 - abs(Double(self.recorder.averagePower(forChannel: 0)) / 50) )
                print("\(power)")
            })
            
//            recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true, block: { [unowned self] _ in
//                guard self.recorder != nil else { return }
//                self.recorder.updateMeters()
//                let power =  min(1, max(0, 1 - abs(Double(self.recorder.averagePower(forChannel: 0)) / 50) ))
//                if self.prevAudioPower == nil {
//                    self.prevAudioPower = power
//                    return
//                }
//                if let preAudioPower = self.prevAudioPower, preAudioPower < 0.25 && power < 0.175 {
//                    self.stopRecordAudio()
//                }
//                self.prevAudioPower = power
//            })
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
