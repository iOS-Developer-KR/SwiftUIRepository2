//
//  SocketPraticeApp.swift
//  SocketPratice
//
//  Created by Taewon Yoon on 11/11/24.
//

import SwiftUI

@main
struct SocketPraticeApp: App {
    @State var socket = WebSocket()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(socket)
        }
    }
}
