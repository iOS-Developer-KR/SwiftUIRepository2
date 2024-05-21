//
//  ContentView.swift
//  GlobalActorExample
//
//  Created by Taewon Yoon on 5/20/24.
//

import SwiftUI

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        
        return ["One", "Two", "Three"]
    }
}

class GlobalActorViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    let manager = MyNewDataManager()
    
    func getData() async {
        
        // 엄청 무거운 메서드들
        let data = await manager.getDataFromDatabase()
        self.dataArray = data
    }
}


struct ContentView: View {
    
    @StateObject private var viewModel = GlobalActorViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.dataArray, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    ContentView()
}
