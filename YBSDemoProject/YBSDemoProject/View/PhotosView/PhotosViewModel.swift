//
//  PhotosViewModel.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 04/09/2023.
//

import Foundation
import Combine
import UIKit
import Kingfisher

class PhotosViewModel: ObservableObject {
    
    let persistence: PersistenceFactoryProtocol
    @Published var photos: [Photo] = []
    @Published var favouritePhotos: [Photo] = []
    private let kingFisherCache = KingFisherCache.shared
    private let networkManager: Networkable
    private var anyCancellable = Set<AnyCancellable>()
    @Published var error: Error?
    @Published var showError = false
    @Published var imagesHasCached = false
    
    init(repo: Networkable = DIContainer.shared.resolve(type:Networkable.self), persistence: PersistenceFactoryProtocol = DIContainer.shared.resolve(type: PersistenceFactoryProtocol.self)) {
        self.networkManager = repo
        self.persistence = persistence
        let coreData = try? persistence.createPersistence(for: .coreData)
        try? coreData?.deleteAllObjects()
        
    }
    
    func getPhoto(of photos: String) {
        networkManager.fetchData(endpoint: RequestEndpoint.photo(of: photos)).sink(receiveCompletion: { [weak self ] completion in
            guard let strong = self else { return }
            switch completion {
            case .finished:
                break
            case .failure(let error):
                strong.showError = true
                strong.error = error
            }
        }, receiveValue: { [weak self ] (response: Welcome) in
            guard let strong = self else { return }
            strong.photos = response.photos.photo
            for (index, photo) in strong.photos.enumerated() {
                
                strong.kingFisherCache.downloadAndCacheImage(imageUrl: photo.imagePath()) { result in
                    switch result {
                    case .success:
                        break
                    case .failure(let error):
                        strong.handleViewModelError("Error downloading and caching image:" , error: error)
                    }
                }
                if index == strong.photos.count - 1 {
                    strong.imagesHasCached = true
                }
            }
        }).store(in: &self.anyCancellable)
    }
    
    func removeALLPhoto() {
        photos.removeAll()
    }
    
    func loadFavouritePhotos() {
        do {
            removeALLPhoto()
            
            if hasFavoritePhotos() {
                let favoritePhotos = try getFavouritePhotos()
                self.favouritePhotos.append(contentsOf: favoritePhotos)
            }
        } catch {
            handleViewModelError("Error loading favorite photos:", error: error)
            self.error = error
            self.showError = true
        }
    }
    
    func getFavouritePhotos() throws -> [Photo] {
        var photoArray: [Photo] = []
        do {
            let coreData = try persistence.createPersistence(for: .coreData)
            if let photos: [Photo] = try coreData.getllObject() {
                photoArray.append(contentsOf: photos)
            }
        } catch {
            throw error
        }
        return photoArray
    }
    
    func hasFavoritePhotos() -> Bool {
        do {
            let favoritePhotos = try getFavouritePhotos()
            return !favoritePhotos.isEmpty
        } catch {
            handleViewModelError("Error loading favorite photos:", error: error)
            return false
        }
    }
    
    private func handleViewModelError(_ printNote: String, error: Error) {
        self.error = error
        self.showError = true
        print(printNote, "\(error)")
    }
}
