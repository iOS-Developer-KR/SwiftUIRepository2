////
////  TTS.swift
////  SpeechTest
////
////  Created by Taewon Yoon on 5/28/24.
////
//
//import Foundation
//import AVFAudio
//import AVFoundation
//import Combine
//
//
//var player: AVAudioPlayer?
//
//func playAudio(url: URL) {
//    do {
//        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
//        try AVAudioSession.sharedInstance().setActive(true)
//
//        /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
//        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
//
//        /* iOS 10 and earlier require the following line:
//        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
//
//        guard let player = player else { return }
//
//        player.play()
//
//    } catch let error {
//        print(error.localizedDescription)
//    }
//}
//
//func tts(text: String) -> AnyPublisher<Data, Error> {
//    let headers: HTTPHeaders = ["Authorization" : "Bearer \(Constants.OpenAIAPIKey)", "Content-Type": "application/json"]
//    let parameters = TTSParameters(
//        model: "tts-1",
//        input: text,
//        voice: "alloy"
//    )
//    return Future { promise in
//        self.performTTSRequest(with: parameters, headers: headers, promise: promise)
//    }
//    .eraseToAnyPublisher()
//}
//
//private func performTTSRequest(with parameters: TTSParameters,
//                               headers: HTTPHeaders,
//                               promise: @escaping (Result<Data, Error>) -> Void) {
//    AF.request("https://api.openai.com/v1/audio/speech", method: .post, parameters: parameters, encoder: JSONParameterEncoder.default, headers: headers)
//        .validate()
//        .responseData { response in
//            switch response.result {
//            case .success(let data):
//                promise(.success(data))
//            case .failure(let error):
//                promise(.failure(error))
//            }
//        }
//}
//
//struct TTSParameters: Codable {
//    let model: String
//    let input: String
//    let voice: String
//}
//
