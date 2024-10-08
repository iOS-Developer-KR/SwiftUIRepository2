//
//  ContentView.swift
//  DataEnssentialTest
//
//  Created by Taewon Yoon on 10/3/24.
//

import SwiftUI

class TestStruct: ObservableObject {
    @Published var number = 0
}

struct DataEnssentialTestView: View {
    
//    @StateObject var testStruct = TestStruct()
//    @ObservedObject var testStruct: TestStruct
    @EnvironmentObject var testStruct: TestStruct
    
    var body: some View {
        MyView()
        
//        Button {
//            testStruct.number += 1
//        } label: {
//            Image(systemName: "plus.app")
//        }
    }
}

struct MyView: View {
    // SceneStorage로 선택된 탭 상태 저장
    @SceneStorage("selectedTab") private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Text("Home Tab")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            Text("Profile Tab")
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
                .tag(1)
        }
    }
}


struct TestView1: View {
    
//    @StateObject var testStruct = TestStruct()
//    @ObservedObject var testStruct: TestStruct
    @EnvironmentObject var testStruct: TestStruct


    
    var body: some View {
        Text("TestView1: \(testStruct.number)")
        TestView2()
    }
}

struct TestView2: View {
    
//    @StateObject var testStruct = TestStruct()
    @EnvironmentObject var testStruct: TestStruct

    
    var body: some View {
        Text("TestView2: \(testStruct.number)")
    }
}

struct TestView3: View {
    
    @StateObject var testStruct = TestStruct()
    
    var body: some View {
        Text("TestView3: \(testStruct.number)")
    }
}

#Preview {
    DataEnssentialTestView(testStruct: .init())
        .environmentObject(TestStruct())
}
