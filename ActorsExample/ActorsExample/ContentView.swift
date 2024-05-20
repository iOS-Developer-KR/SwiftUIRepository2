//
//  ContentView.swift
//  ActorsExample
//
//  Created by Taewon Yoon on 5/20/24.
//

import SwiftUI

class MyDataManager {
    
    static let instance = MyDataManager()
    private init() { }
    
    var data: [String] = []
    private let queue = DispatchQueue(label: "com.MyApp.MyDataManager") // debug log에 사용될 예정
    
    func getRandomData(completionHandler: @escaping (_ title: String?) -> Void) -> () {
        
        queue.async {
            self.data.append(UUID().uuidString)
            print(Thread.current)
            completionHandler(self.data.randomElement())
        }
    }
}

actor MyActorDataManager {
    
    static let instance = MyActorDataManager()
    private init() { }
    
    var data: [String] = []
    
    func getRandomData() -> String? {
        
        self.data.append(UUID().uuidString)
        print(Thread.current)
        return self.data.randomElement()
    }
    
    nonisolated func getSavedData() -> String {
        return "NEW DATA"
    }
}

struct HomeView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            Task {
                if let data = await manager.getRandomData() {
                    await MainActor.run {
                        self.text = data
                    }
                }
            }
//            DispatchQueue.global(qos: .background).async {
//
//                manager.getRandomData { title in
//                    if let data = title {
//                        self.text = data
//                    }
//                }
//            }
        })
    }
}

struct BrowseView: View {
    
    let manager = MyActorDataManager.instance
    @State private var text: String = ""
    let timer = Timer.publish(every: 0.1, tolerance: nil, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8).ignoresSafeArea()
            Text("가나다라")
            Text(text)
                .font(.headline)
        }
        .onReceive(timer, perform: { _ in
            DispatchQueue.global(qos: .default).async {
                Task {
                    if let data = await manager.getRandomData() {
                        await MainActor.run {
                            self.text = data
                        }
                    }
                }
//                manager.getRandomData { title in
//                    if let data = title {
//                        self.text = data
//                    }
//                }
            }
        })
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseView()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
            
        }
    }
}

#Preview {
    ContentView()
}
