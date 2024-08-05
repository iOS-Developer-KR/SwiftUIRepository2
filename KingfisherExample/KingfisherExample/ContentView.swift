//
//  ContentView.swift
//  KingfisherExample
//
//  Created by Taewon Yoon on 6/6/24.
//

import SwiftUI
import Kingfisher


struct ContentView: View {
    
    var body: some View {
        KingfisherView(url: "https://picsum.photos/id/237/200/300", urls: [URL(string: "https://picsum.photos/id/237/200/300")!], contentModel: .fill)
    }
}

#Preview {
    ContentView()
}
