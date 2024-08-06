//
//  ContentView2.swift
//  DragGestureExample
//
//  Created by Taewon Yoon on 8/5/24.
//

import SwiftUI

struct ContentView2: View {
    
    @State var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.85
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            MySignUpView()
                .offset(y: startingOffsetY)
                .offset(y: currentDragOffsetY)
                .offset(y: endingOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            withAnimation(.spring()) {
                                currentDragOffsetY = value.translation.height
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if currentDragOffsetY < -150 {
                                    endingOffsetY = -startingOffsetY
                                } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                                    endingOffsetY = 0
                                }
                                
                                    currentDragOffsetY = 0
                                
                                
                            }
                        }
                )
            
            Text("\(currentDragOffsetY)")
        }
    }
}

#Preview {
    ContentView2()
}

struct MySignUpView: View {
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Image(systemName: "chevron.up")
                    .padding(.top)
                
                Text("Sign up")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Image(systemName: "flame.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                
                Text("This is the description for out app.")
                    .multilineTextAlignment(.center)
                
                Text("CREATE AN ACCOUNT")
                    .foregroundStyle(.white)
                    .font(.headline)
                    .padding()
                    .padding(.horizontal)
                    .background(Color.black)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .ignoresSafeArea(edges: .bottom)
    }
        
}
