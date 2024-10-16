//
//  ContentView.swift
//  CloudKitTest
//
//  Created by Taewon Yoon on 10/16/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(CloudKitUserViewModel.self) var vm
    
    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description.uppercased())")
            Text(vm.error)
            Text("이름: \(vm.userName)")
            Text(vm.permissionStatus.description.uppercased())
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environment(CloudKitUserViewModel())
}
