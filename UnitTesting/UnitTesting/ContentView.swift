//
//  ContentView.swift
//  UnitTesting
//
//  Created by Taewon Yoon on 10/8/24.
//

import SwiftUI

/*
 1. Unit Tests
 - 앱의 비즈니스 로직을 테스트
 
 2. UI Tests
 - 앱의 UI 를 테스트
 */



struct ContentView: View {

    @StateObject private var vm: UnitTestingViewModel

    init(isPremium: Bool) {
        _vm = StateObject(wrappedValue: UnitTestingViewModel(isPremium: isPremium))
    }
    
    var body: some View {
        Text(vm.isPremium.description)
    }

    
}

#Preview {
    ContentView(isPremium: true)
}
