//
//  ContentView.swift
//  TaskExample
//
//  Created by Taewon Yoon on 5/16/24.
//

import SwiftUI


class TaskExampleModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil

    func fetchImage() async {
        try? await Task.sleep(nanoseconds: 5_000_000_000)
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let image = UIImage(data: data)
            await MainActor.run {
                self.image = image
            }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, response ) = try await URLSession.shared.data(from: url)
            
            let image = UIImage(data: data)
            self.image2 = image
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskExampleHomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("클릭") {
                    ContentView()
                }
            }
        }
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = TaskExampleModel()
    @State private var fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            self.fetchImageTask?.cancel()
//        }
//        .onAppear {
//            self.fetchImageTask = Task {
//                await viewModel.fetchImage()
//            }
////            Task {
////                print(Thread.current)
////                print(Task.currentPriority)
////                await viewModel.fetchImage()
////            }
////            Task {
////                print(Thread.current)
////                print(Task.currentPriority)
////                await viewModel.fetchImage()
////            }
////            Task(priority: .high) {
//////                try? await Task.sleep(nanoseconds: 2_000_000_000)
////                await Task.yield()
////                print("high : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .userInitiated) {
////                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .medium) {
////                print("medium : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .low) {
////                print("low : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .utility) {
////                print("uitility : \(Thread.current) : \(Task.currentPriority)")
////            }
////            Task(priority: .background) {
////                print("background : \(Thread.current) : \(Task.currentPriority)")
////            }
//
//            Task(priority: .userInitiated) {
//                print("userInitiated : \(Thread.current) : \(Task.currentPriority)")
//            }
//
//        }
    }
}

#Preview {
    ContentView()
}
