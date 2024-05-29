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

    var captureURL: URL { // 캡쳐한 url을 저장
        (FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent("recording.m4a", conformingTo: .audio))!
    }
    
    override init() {
        super.init()
        do {
            try recordingSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            
            AVAudioApplication.requestRecordPermission { [unowned self] allowed in
                if !allowed {
                    print("Recording not allowed by the user" as! Error)
                }
            }
        } catch {
            print("초기화오류" + error.localizedDescription)
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
            print("녹음이 되고있긴 한거지?")
            recorder.record()
            recorder.delegate = self
        } catch {
            print("녹음에러:" + error.localizedDescription)
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
            print("녹음재생시작")
            audioPlayer = try AVAudioPlayer(contentsOf: captureURL)
            audioPlayer.play()
        } catch {
            print("녹음재생에러" + error.localizedDescription)
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
