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
    var recordingTimer: Timer?
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
                audioPower =  max(0, 1 - abs(Double(self.recorder.averagePower(forChannel: 0)) / 50) )
            })
            
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true, block: { [unowned self] _ in
                guard self.recorder != nil else { return }
                self.recorder.updateMeters()
                let power =  max(0, 1 - abs(Double(self.recorder.averagePower(forChannel: 0)) / 50) )
                if self.prevAudioPower == nil {
                    self.prevAudioPower = power
                    return
                }
                // preAudioPower에 1.6초마다 측정한 데이터를 데이터를 넣고 1.6초마다 측정한 데이터와 0.2초마다 측정한 데이터의 소리가 무의미한 정도의 크기라면 녹음을 멈춘다.
                if let preAudioPower = self.prevAudioPower, preAudioPower < 0.25 && power < 0.175 {
                    self.stopRecordAudio()
                }
                print(power)
                self.prevAudioPower = power // 이전 데이터를 저장하는 변수에 1.6초마다 기록한 데이터값을 넣는다.
            })
        } catch {
            resetValues()
            print(error.localizedDescription)
        }
    }
    
    func pauseRecordAudio() {
        recorder.pause()
    }
    
    func stopRecordAudio() {
        resetValues()
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
    
    func resetValues() {
        audioPower = 0
        prevAudioPower = nil
        recorder.stop()
        recorder = nil
        audioPlayer?.stop()
        audioPlayer = nil
        recordingTimer?.invalidate()
        recordingTimer = nil
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    
}

extension AudioRecorder: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        playRecordAudio()
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: (any Error)?) {
        
    }
}
