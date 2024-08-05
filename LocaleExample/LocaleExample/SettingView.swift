//
//  ContentView.swift
//  SettingViewUI
//
//  Created by Taewon Yoon on 6/1/24.
//

import SwiftUI
import SwiftData

enum Language: String, CaseIterable {
    case en
    case ko

    var value: String {
        switch self {
        case .en:
            return "en"
        case .ko:
            return "ko"
        }
    }
}


struct SettingView: View {
    @Environment(LanguageSetting.self) var languageSettings
    @AppStorage("userLanguageKey") private var locale = "en"
    @State var language: Language = .ko

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Setting")) {
                    Picker("Select Language", selection: $language) {
                        Text("Korean").tag(Language.ko)
                        Text("English").tag(Language.en)
                    }
                }
            }
        }
        .onChange(of: language, { oldValue, newValue in
            languageSettings.locale = Locale(identifier: newValue.value)
            locale = newValue.value
        })
    }
}

#Preview {
    SettingView()
        .environment(LanguageSetting())
}
