//
//  ShareLinkTestApp.swift
//  ShareLinkTest
//
//  Created by Taewon Yoon on 10/22/24.
//

import SwiftUI

@main
struct ShareLinkTestApp: App {
    var body: some Scene {
        WindowGroup {
            ShareLinkSheetView(photo: .init(image: Image(systemName: "book"), caption: "내가 설정한 caption", icon: Image(systemName: "Circle")))
        }
    }
}
