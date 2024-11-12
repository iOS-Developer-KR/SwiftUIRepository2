//
//  ContentView.swift
//  ShareLinkTest
//
//  Created by Taewon Yoon on 10/22/24.
//

import SwiftUI

struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }


    public var image: Image
    public var caption: String
    public var icon: Image
}

struct ShareLinkSheetView: View {
    let photo: Photo


    var body: some View {
        
        ShareLink(item: photo,
                  subject: Text("Title"),
                  message: Text("Check this out!"),
                  preview: SharePreview("제공되는 이미지", image: photo.image, icon: photo.icon))
        
        ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!)
        
        ShareLink(item: URL(string: "https://developer.apple.com/xcode/swiftui/")!) {
            Label("Share", image: "MyCustomShareIcon")
        }
        
        ShareLink(
            item: photo,
            subject: Text("Cool Photo"),
            message: Text("Check it out!"),
            preview: SharePreview(
                photo.caption,
                image: photo.image))
    }
}

#Preview {
    ShareLinkSheetView(photo: Photo(image: Image(systemName: "Circle"), caption: "", icon: Image(systemName: "Circle")))
}
