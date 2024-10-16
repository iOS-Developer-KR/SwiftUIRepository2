//
//  CloudKitTestApp.swift
//  CloudKitTest
//
//  Created by Taewon Yoon on 10/16/24.
//

import SwiftUI
import SwiftData

@main
struct CloudKitTestApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(CloudKitUserViewModel())
        }
    }
}
