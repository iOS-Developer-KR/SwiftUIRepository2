//
//  DataEnssentialTestApp.swift
//  DataEnssentialTest
//
//  Created by Taewon Yoon on 10/3/24.
//

import SwiftUI

@main
struct DataEnssentialTestApp: App {
    
    @StateObject private var testStruct = TestStruct()
    var body: some Scene {
        WindowGroup {
            DataEnssentialTestView()
                .environmentObject(testStruct)
        }
    }
}
