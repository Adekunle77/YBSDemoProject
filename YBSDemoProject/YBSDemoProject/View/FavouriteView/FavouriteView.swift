//
//  FavouriteView.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 10/09/2023.
//

import SwiftUI

struct FavouriteView: View {
    
    var photos: [Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    var body: some View {
        List {
            ForEach(0..<photos.count, id: \.self) { index in
                let photo = photos[index]
                PhotoView(photo: photo)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}
