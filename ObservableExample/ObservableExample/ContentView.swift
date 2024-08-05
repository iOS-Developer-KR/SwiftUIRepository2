//
//  ContentView.swift
//  ObservableExample
//
//  Created by Taewon Yoon on 6/4/24.
//

import SwiftUI

actor TitleDatabase {
    
    func getNewTitle() -> String {
        "Some new title!"
    }
}

@Observable class ObservableViewModel: ObservableObject {
    
    let database = TitleDatabase()
    @MainActor var title: String = "Starting title"
    
    func updateTitle() async  {
        Task { @MainActor in
            title = await database.getNewTitle()
            print(Thread.current)
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = ObservableViewModel()
    
    var body: some View {
        Text(viewModel.title)
            .task {
                await viewModel.updateTitle()
            }
    }
}

#Preview {
    ContentView()
}
