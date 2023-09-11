//
//  DetailPhotoViewModel.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 10/09/2023.
//

import Foundation
import Combine

class DetailPhotoViewModel: ObservableObject {
    let persistence: PersistenceFactoryProtocol
    @Published var error: Error?
    @Published var showError = false
    
    init(persistence: PersistenceFactoryProtocol = DIContainer.shared.resolve(type: PersistenceFactoryProtocol.self)) {
        self.persistence = persistence
    }
    
    func save(_ photo: Photo) {
          do {
              let coreData = try persistence.createPersistence(for: .coreData)
              try coreData.save(object: photo)
          } catch {
              print("DetailPhotoViewModel error: \(error)")
              self.error = error
              self.showError = true
          }
      }
    
      func remove(_ photo: Photo) {
          do {
              let coreData = try persistence.createPersistence(for: .coreData)
              try coreData.delete(object: photo)
          } catch {
              print(" DetailPhotoViewModel error: \(error)")
              self.error = error
              self.showError = true
          }
      }
}
