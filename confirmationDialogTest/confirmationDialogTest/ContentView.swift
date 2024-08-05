//
//  ContentView.swift
//  confirmationDialogTest
//
//  Created by Taewon Yoon on 6/3/24.
//

import SwiftUI

struct ContentView: View {
    @State var pressed: Bool = false
    
    var body: some View {
        Button {
            pressed.toggle()
        } label: {
            Text("버튼")
        }
        .confirmationDialog("confimationDialog입니다", isPresented: $pressed) {
            Button {
                
            } label: {
                Text("버튼1")
            }
            Button {
                
            } label: {
                Text("버튼2")
            }
            Button {
                
            } label: {
                Text("버튼3")
            }
        }
    }
}

#Preview {
    ContentView()
}
