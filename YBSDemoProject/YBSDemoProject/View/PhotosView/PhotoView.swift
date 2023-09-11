//
//  PhotoView.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import SwiftUI
import Kingfisher

struct PhotoView: View {
    private let imageMaxWidth = UIScreen.main.bounds.width - 20
    private let kingFisherCache = KingFisherCache.shared

    let photo: Photo
    @State private var cachedImage: UIImage?

    init(photo: Photo) {
        self.photo = photo
        self._cachedImage = State(initialValue: nil)
    }

    var body: some View {
        VStack {
            if let cachedImage = cachedImage {
                Image(uiImage: cachedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: imageMaxWidth)
                HStack {
                    Text(photo.title)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }
            } else {
                CommentedImage()
                CommentedText()
            }
        }
        .onAppear {
            kingFisherCache.retrieveCachedImage(from: photo.imagePath()) { result in
                switch result {
                case .success(let image):
                    cachedImage = image
                case .failure(let error):
                    print("PhotoView Error: \(error)")
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct CommentedImage: View {
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: UIScreen.main.bounds.width - 20)
    }
}

struct CommentedText: View {
    var body: some View {
        HStack {
            Text("Photo Title")
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
    }
}
