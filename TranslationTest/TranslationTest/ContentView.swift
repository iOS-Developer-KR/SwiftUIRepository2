//
//  ContentView.swift
//  TranslationTest
//
//  Created by Taewon Yoon on 10/4/24.
//

import SwiftUI
import Translation
import NaturalLanguage

struct ContentView: View {
    @State private var sourceText: String = ""
    @State private var targetText: String?
    @State private var configuration: TranslationSession.Configuration?
    
    
    var body: some View {
        VStack {
            TextField(text: $sourceText) { Text("textfield") }
            
            Text(targetText ?? sourceText)
                .translationTask(configuration) { session in
                    
                    
                    do {
//                        try await session.prepareTranslation()
                        await translate(using: session)
                        let response = try await session.translate(sourceText)
                        targetText = response.targetText
                    } catch {
                        print(error.localizedDescription)
                    }

                }
            
            Button {
                if configuration == nil {
                    configuration = .init(
                                          target: Locale.Language(identifier: "ko"))
                } else {
                    configuration?.invalidate()
                }
            } label: {
                Text("Button")
            }
            
            
        }
        .padding()
        .onAppear {
            
        }
    }
    
    func identifyLanguage(of sample: String) -> Locale.Language? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(sample)
        guard let language = recognizer.dominantLanguage else { return nil }
        return Locale.Language(identifier: language.rawValue)
    }
  
//    func translate(using session: TranslationSession) async {
//        do {
//            var requests: [TranslationSession.Request] = []
//            let koreanRequest = TranslationSession.Request(sourceText: "안녕")
//            let englishRequest = TranslationSession.Request(sourceText: "no thanks")
//            let germanRequest = TranslationSession.Request(sourceText: "Guten Abend")
//            requests.append(koreanRequest)
//            requests.append(englishRequest)
//            requests.append(germanRequest)
//            for try await resposne in session.translate(batch: requests) {
//                print(resposne.targetText)
//            }
//        } catch {
//
//        }
//    }
    
    func translate(using session: TranslationSession) async {
        do {
            print("번역")
//            let koreanRequests: [TranslationSession.Request] = [.init(sourceText: "안녕", clientIdentifier: "\(UUID())")]
            let englishRequests: [TranslationSession.Request] = [TranslationSession.Request(sourceText: "no thanks")]
            let germanRequests: [TranslationSession.Request] = [TranslationSession.Request(sourceText: "Guten Abend")]

//            for try await resposne in session.translate(batch: koreanRequests) {
//                print(resposne.targetText)
//            }
            
            for try await resposne in session.translate(batch: englishRequests) {
                print(resposne.targetText)
            }
//            
            for try await resposne in session.translate(batch: germanRequests) {
                print(resposne.targetText)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

#Preview {
    ContentView()
}
