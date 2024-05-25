//
//  ContentView.swift
//  AsyncPublisherExample
//
//  Created by Taewon Yoon on 5/24/24.
//

import SwiftUI
import Combine

class AsyncPublisherDataManager {
    
    @Published var myData: [String] = []
    
    func addData() async {
        myData.append("Apple")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Banana")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Watermelon")
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        myData.append("Orange")
    }
}

class AsyncPublisherViewModel: ObservableObject {
    
    @MainActor @Published var dataArray: [String] = []
    let manager = AsyncPublisherDataManager()
    var cancellable = Set<AnyCancellable>()
    
    init() {
        print("1")
        addSubscribers()
    }
    
    private func addSubscribers() {
        print("11")
        Task {
            
            //            await MainActor.run {
            //                self.dataArray = ["ONE"]
            //            }
            //
                        for await value in manager.$myData.values { // .value = AsyncPublisher
                            await MainActor.run {
                                self.dataArray = value
                            }
                        }
            //
            //            await MainActor.run {
            //                self.dataArray = ["TWO"]
            //            }
            //        }
            
//            await MainActor.run {
//                manager.$myData
//                    .receive(on: DispatchQueue.main)
//                    .sink { dataArray in
//                        self.dataArray = dataArray
//                    }
//                    .store(in: &cancellable)
//            }
        }
    }
    
    func start() async {
        await manager.addData()
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = AsyncPublisherViewModel()
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
            await viewModel.start()
        }
    }
}

#Preview {
    ContentView()
}
