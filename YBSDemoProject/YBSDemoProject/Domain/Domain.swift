//
//  Domain.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Foundation
import SwiftUI

struct Welcome: Codable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
    
    func imagePath() -> String {
         "https://farm\(self.farm).static.flickr.com/\(self.server)/\(self.id)_\(self.secret).jpg"
    }
}

extension Photo: Identifiable {}
