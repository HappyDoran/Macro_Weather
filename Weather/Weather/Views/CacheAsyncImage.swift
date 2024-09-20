//
//  CacheAsyncImage.swift
//  Weather
//
//  Created by Doran on 9/20/24.
//

//import SwiftUI
//
//struct CacheAsyncImage: View {
//    private let url: URL
//    @State private var image: Image?
//    
//    init(url: URL) {
//        self.url = url
//    }
//    
//    var body: some View {
//        Group {
//            if let image = image {
//                image
//                    .resizable()
//                    .scaledToFit()
//            }
//            else {
//                ProgressView()
//            }
//        }
//        .onAppear(perform: loadImage)
//    }
//}
//
//extension CacheAsyncImage {
//    private func loadImage() {
//        if let cachedImage = ImageCache[url] {
//            self.image = cachedImage
//        }
//        else {
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                if let data = data, let uiImage = UIImage(data: data) {
//                    let image = Image(uiImage: uiImage)
//                    DispatchQueue.main.async {
//                        ImageCache[url] = image
//                        self.image = image
//                    }
//                }
//            }.resume()
//        }
//    }
//}
//
//fileprivate class ImageCache {
//    // 무슨 역할을 하는지 몰라서 한줄한줄 주석을 달아놨습니다.
//    // 정적 프라이빗 변수로 URL을 키로, Image를 값으로 하는 딕셔너리를 생성합니다.
//    // 이 딕셔너리가 실제로 이미지를 메모리에 캐시하는 역할을 합니다.
//    static private var cache: [URL: Image] = [:]
//    
//    // 서브스크립트를 정의하여 딕셔너리에 쉽게 접근할 수 있게 합니다.
//    static subscript(url: URL) -> Image? {
//        get {
//            self.cache[url]
//        }
//        set {
//            self.cache[url] = newValue
//        }
//    }
//}

import SwiftUI

struct CacheAsyncImage<Placeholder: View, Content: View>: View {
    private let url: URL
    @State private var image: Image?
    @State private var isLoading: Bool = false
    
    private let placeholder: () -> Placeholder
    private let content: (Image) -> Content

    init(
        url: URL,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder content: @escaping (Image) -> Content
    ) {
        self.url = url
        self.placeholder = placeholder
        self.content = content
    }

    var body: some View {
        Group {
            if let image = image {
                content(image)
            } else if isLoading {
                placeholder()
            } else {
                placeholder()
                    .onAppear(perform: loadImage)
            }
        }
    }
}

extension CacheAsyncImage {
    private func loadImage() {
        if let cachedImage = ImageCache[url] {
            self.image = cachedImage
        } else {
            isLoading = true
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let uiImage = UIImage(data: data) {
                    let image = Image(uiImage: uiImage)
                    DispatchQueue.main.async {
                        ImageCache[url] = image
                        self.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = nil // 실패 시 nil로 설정
                    }
                }
                DispatchQueue.main.async {
                    isLoading = false
                }
            }.resume()
        }
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get {
            self.cache[url]
        }
        set {
            self.cache[url] = newValue
        }
    }
}
