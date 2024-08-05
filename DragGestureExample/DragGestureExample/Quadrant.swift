//
//  Quadrant.swift
//  DragGestureExample
//
//  Created by Taewon Yoon on 8/5/24.
//

import SwiftUI

struct Crosshairs: View {
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let midX = width / 2
            let midY = height / 2
            
            Path { path in
                // Horizontal line
                path.move(to: CGPoint(x: 0, y: midY))
                path.addLine(to: CGPoint(x: width, y: midY))
                
                // Vertical line
                path.move(to: CGPoint(x: midX, y: 0))
                path.addLine(to: CGPoint(x: midX, y: height))
            }
            .stroke(Color.primary, lineWidth: 1)
        }
    }
}

struct Quadrant: View {
    var body: some View {
        ZStack {
            ZStack {
                Crosshairs()
                Rectangle()
                    .stroke(Color.primary)
                Image(systemName: "circle")
                    .offset(x: 0, y: 0)
            }
            .frame(width: 120, height: 120)
            .offset(x: 50, y: 100)
            .background(Color.gray)
            
            Image(systemName: "circle")
                .resizable()
                .offset(x: 0, y: 0)
                .frame(width: 50, height: 50)
                
        }
        .frame(width: 360, height: 360)
        .background(Color.blue)
    }
}

#Preview {
    Quadrant()
}
