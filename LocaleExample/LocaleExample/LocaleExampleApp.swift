//
//  LocaleExampleApp.swift
//  LocaleExample
//
//  Created by Taewon Yoon on 6/6/24.
//

import SwiftUI

@main
struct LocaleExampleApp: App {
    @State private var language = LanguageSetting()
    @AppStorage("userLanguageKey") private var locale = "en"

    init() {
        language.locale = Locale(identifier: locale)
    }
    var body: some Scene {
        WindowGroup {
            SettingView()
        }
        .environment(\.locale, language.locale)
        .environment(language)
    }
}
