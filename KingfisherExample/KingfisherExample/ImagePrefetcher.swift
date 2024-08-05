//
//  ImagePrefetcher.swift
//  KingfisherExample
//
//  Created by Taewon Yoon on 6/6/24.
//

import SwiftUI
import Kingfisher

class ImagePrefetcher {
    
    var prefetcher: [[URL]: Kingfisher.ImagePrefetcher] = [:]
    
    // 데이터를 미리 가져와서 로컬 디스크에 저장된 데이터에 저장하여 다음에 사용될 때 바로 가져다 쓸 수 있게 한다
    func startPrefetching(urls: [URL]) {
        prefetcher[urls] = Kingfisher.ImagePrefetcher(urls: urls)
        prefetcher[urls]?.start()
    }
    
    func stopPrefetching(urls: [URL]) {
        prefetcher[urls]?.stop()
    }
    
}
