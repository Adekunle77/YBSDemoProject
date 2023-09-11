//
//  KingFisherCache.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 11/09/2023.
//

import Kingfisher
import UIKit

class KingFisherCache {
    
    static let shared = KingFisherCache()
    private init() {}
    
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
    
    func downloadAndCacheImage(imageUrl: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let imageUrl = URL(string: imageUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            completion(.failure(error))
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: imageUrl, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(_):
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
