//
//  CacheAsyncImage.swift
//  Weather
//
//  Created by Doran on 9/20/24.
//

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
