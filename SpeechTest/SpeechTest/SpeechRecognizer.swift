
import AVFoundation
import Foundation

@Observable
class ViewModel: NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var selectedVoid = VoidType.alloy
    var state = VoiceChatState.idle {
        didSet { print(state) }
    }
    var isIdle: Bool {
        if case .idle = state {
            return true
        }
        return false
    }
    
    var audioPlayer: AVAudioPlayer!
    var audioRecorder: AVAudioRecorder!
    
    var recordingSession = AVAudioSession.sharedInstance()
    
    var animationTimer: Timer? //
    var recordingTimer: Timer? // 유저가 말을 멈췄을 때를 위해 사용
    var audioPower = 0.0
    var prevAudioPower: Double?
    var processingSpeechTask: Task<Void, Never>?
    
    
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
                    self.state = .error("Recording not allowed by the user" as! Error)
                }
            }
        } catch {
            state = .error(error)
        }
    }
    
    
    
    func startCaptureAudio() {
        resetValues()
        state = .recordingSpeech
        do {
            audioRecorder = try AVAudioRecorder(url: captureURL, settings: [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ])
            audioRecorder.isMeteringEnabled = true
            audioRecorder.delegate = self
            audioRecorder.record()
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self] _ in
                guard self.audioRecorder != nil else { return }
                self.audioRecorder.updateMeters()
                let power =  min(1, max(0, 1 - abs(Double(self.audioRecorder.averagePower(forChannel: 0)) / 50) ))
                self.audioPower = power
            })
            
            recordingTimer = Timer.scheduledTimer(withTimeInterval: 1.6, repeats: true, block: { [unowned self] _ in
                guard self.audioRecorder != nil else { return }
                self.audioRecorder.updateMeters()
                let power =  min(1, max(0, 1 - abs(Double(self.audioRecorder.averagePower(forChannel: 0)) / 50) ))
                if self.prevAudioPower == nil {
                    self.prevAudioPower = power
                    return
                }
                if let preAudioPower = self.prevAudioPower, preAudioPower < 0.25 && power < 0.175 {
                    self.finishCaptureAudio()
                }
                self.prevAudioPower = power
            })
            
        } catch {
            resetValues()
            state = .error(error)
        }
    }
    
    func finishCaptureAudio() {
        resetValues()
        do {
          let data = try Data(contentsOf: captureURL)
            try playAudio(data: data)
        } catch {
            state = .error(error)
            resetValues()
        }
    }
    
//    func processSpeechTask(audioData: Data) -> Task<Void, Never> {
//        
//    }
    
    func playAudio(data: Data) throws {
        self.state = .playingSpeech
        audioPlayer = try AVAudioPlayer(data: data)
        audioPlayer.isMeteringEnabled = true
        audioPlayer.delegate = self
        audioPlayer.play()
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { [unowned self] _ in
            guard self.audioPlayer != nil else { return }
            self.audioPlayer.updateMeters()
            let power =  min(1, max(0, 1 - abs(Double(self.audioPlayer.averagePower(forChannel: 0)) / 160) ))
            self.audioPower = power
        })
    }
    
    func cancelRecording() {
        resetValues()
        state = .idle
    }
    
    func cancelProcessingTask() {
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            resetValues() // 녹음이 끝났다면 초기화시키기
            state = .idle
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        resetValues()
        state = .idle
    }
    
    func resetValues() {
        audioPower = 0
        prevAudioPower = nil
        audioRecorder?.stop()
        audioRecorder = nil
        audioPlayer?.stop()
        audioPlayer = nil
        recordingTimer?.invalidate()
        recordingTimer = nil
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
}
