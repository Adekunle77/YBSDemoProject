//
//  DetailPhotoView.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import SwiftUI
import Kingfisher

struct DetailPhotoView: View {
    @ObservedObject private var viewModel = DetailPhotoViewModel()
    private let imageMaxWidth = UIScreen.main.bounds.width - 20
    let photo: Photo
    @State private var cachedImage: UIImage?
    @State private var isHeartFilled = false
    
    init(photo: Photo) {
        self.photo = photo
    }
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    isHeartFilled.toggle()
                    if isHeartFilled {
                           viewModel.save(photo)
                       } else {
                           viewModel.remove(photo)
                       }
                }) {
                    Text("Add to favourites")
                    Image(systemName: isHeartFilled ? "heart.fill" : "heart")
                        .foregroundColor(isHeartFilled ? .red : .black)
                }
                .padding(16)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 5)
                Spacer()
            }
            
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
            VStack {
                Text("Title: \(photo.title)")
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                Text("ID: \(photo.id)")
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
                Text("Owner: \(photo.owner)")
                    .multilineTextAlignment(.center)
                    .padding(.top, 30)
            }
        }
        .onAppear {
            retrieveCachedImage(from: photo.imagePath()) { result in
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
    
    func retrieveCachedImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let imageUrl = URL(string: urlString) {
            ImageCache.default.retrieveImage(forKey: imageUrl.absoluteString, options: nil) { result in
                switch result {
                case .success(let value):
                    if let cachedImage = value.image {
                        
                        completion(.success(cachedImage))
                    } else {
                        let error = NSError(domain: "Image is nil", code: 0, userInfo: nil)
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
        }
    }
}
