//
//  ContentView.swift
//  GlobalActorExample
//
//  Created by Taewon Yoon on 5/20/24.
//

import SwiftUI

@globalActor struct MyGlobalActor {
    
    static var shared = MyNewDataManager()
}

actor MyNewDataManager {
    
    func getDataFromDatabase() -> [String] {
        print(Thread.current)
        return ["One", "Two", "Three", "Four"]
    }
}

class GlobalActorViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = MyGlobalActor.shared
    
    @MyGlobalActor
    func getData() async {
        // 엄청 무거운 작업을 Main Thread 에서 작업한다면 문제가 발생
        let data = await manager.getDataFromDatabase() // actor이므로 자동 async 코드로 인식
        await MainActor.run(body: {
             self.dataArray = data
        })
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
        .onAppear {
            print(Thread.current)
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    ContentView()
}
