//
//  KingfisherView.swift
//  KingfisherExample
//
//  Created by Taewon Yoon on 6/6/24.
//

import SwiftUI
import Kingfisher

struct KingfisherView: View {
    
    let imagePrefetcher = ImagePrefetcher()
    let url: String
    let urls: [URL]
    var contentModel: SwiftUI.ContentMode = .fill
    
    var body: some View {
        KFImage(URL(string: "https://picsum.photos/id/237/200/300")!)
            .placeholder {
                Color.red
            }
            .resizable()
            .onProgress { receivedSize, totalSize in
                
            }
            .onSuccess { result in
                
            }
            .onFailure { error in
                
            }
            .task {
                imagePrefetcher.startPrefetching(urls: urls)
            }
    }
}

//#Preview {
//    KingfisherView(url: "https://picsum.photos/id/237/200/300")
//}
