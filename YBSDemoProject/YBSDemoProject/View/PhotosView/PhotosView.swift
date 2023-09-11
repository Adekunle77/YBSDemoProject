//
//  PhotosView.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import SwiftUI
import Combine

struct PhotosView: View {
    private var anyCancellable = Set<AnyCancellable>()
    @StateObject private var viewModel = PhotosViewModel()
    @State private var enteredText: String = ""
    @State private var isShowingPhotoDetail = false
    @State private var isKeyboardVisible = false
    @State private var isShowingFavourite = false
    @State private var selectedPhoto = Photo(id: "", owner: "", secret: "", server: "", farm: 0, title: "", ispublic: 0, isfriend: 0, isfamily: 0)
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.imagesHasCached {
                    List {
                        ForEach(0..<viewModel.photos.count, id: \.self) { index in
                            let photo = viewModel.photos[index]
                            PhotoView(photo: photo)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                                .onTapGesture {
                                    selectedPhoto = photo
                                    isShowingPhotoDetail = true
                                }
                        }
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                Spacer()
                HStack {
                Button(action: {
                    if viewModel.hasFavoritePhotos() {
                        viewModel.loadFavouritePhotos()
                        isShowingFavourite = true
                    }
                }) {
                    Text("View favourites")
                    Image(systemName: viewModel.hasFavoritePhotos() ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.hasFavoritePhotos() ? .red : .black)
                }                    
                }
                TextField("Type something...", text: $enteredText)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    .onTapGesture {
                        isKeyboardVisible = true
                    }
                    Button("Get Photos") {
                        viewModel.removeALLPhoto()
                        viewModel.imagesHasCached = false
                        viewModel.getPhoto(of: enteredText)
                        enteredText = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isKeyboardVisible = false
                    }
                    .padding(.bottom, 50)
                
            }
            .sheet(isPresented: $isShowingPhotoDetail) {
                if let selectedPhoto = selectedPhoto {
                    DetailPhotoView(photo: selectedPhoto)
                }
            }
            .onChange(of: isShowingPhotoDetail) { _ in
                _ = viewModel.hasFavoritePhotos()
            }
            .sheet(isPresented: $isShowingFavourite) {
                FavouriteView(photos: self.viewModel.favouritePhotos)
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(title: Text("Error"), message: Text(viewModel.error?.localizedDescription ?? "Sorry, there is an error."), dismissButton: .default(Text("OK")))
            }
            .onReceive(Publishers.keyboardHeight) { _ in }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isKeyboardVisible = false
        }
        .navigationBarHidden(true)
    }
}

