//
//  ContentView.swift
//  SendableExample
//
//  Created by Taewon Yoon on 5/24/24.
//

import SwiftUI


actor CurrentUserManager {
    
    func updateDatabase(userInfo: MyUserInfo) {
        
    }
    
}

struct MyUserInfo: Sendable {
    let name: String
}

final class MyClassUserInfo: @unchecked Sendable {
    private var name: String
    let queue = DispatchQueue(label: "com.MyApp.MyClassUserInfo") // 클래스를 queue로 만듬
    
    init(name: String) {
        self.name = name
    }
    
    func updateName(name: String) {
        queue.async {
            self.name = name
        }
    }
}

class SendableExampleViewModel: ObservableObject {
    
    let manager = CurrentUserManager()
    
    func updateCurrentUserInfo() async {
        
        let info = MyUserInfo(name: "USER INFO")
        
        await manager.updateDatabase(userInfo: info)
    }
}

struct ContentView: View {
    
    @StateObject private var viewModel = SendableExampleViewModel()
    
    var body: some View {
        Text("Hello, World")
            .task {
                
            }
    }
}

#Preview {
    ContentView()
}
