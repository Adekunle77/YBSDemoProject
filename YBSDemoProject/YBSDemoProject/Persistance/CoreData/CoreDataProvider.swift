//
//  CoreDataProvider.swift
//  YBSDemoProject
//
//  Created by Ade Adegoke on 06/09/2023.
//

import CoreData
import UIKit
import SwiftUI

class CoreDataProvider {
    
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: Save
    private func savePhoto(_ photo: Photo) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: AppConstants.coreDataPhotoEntity, in: persistentContainer.viewContext) else { return }
        let newCachedImage = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
        
        newCachedImage.setValue(photo.farm, forKeyPath: AppConstants.photoEntityFarm)
        newCachedImage.setValue(photo.id, forKeyPath: AppConstants.photoEntityID)
        newCachedImage.setValue(photo.isfamily , forKeyPath: AppConstants.photoEntityIsFamily)
        newCachedImage.setValue(photo.isfriend , forKeyPath: AppConstants.photoEntityIsFriend)
        newCachedImage.setValue(photo.ispublic , forKeyPath: AppConstants.photoEntityIsPublic)
        newCachedImage.setValue(photo.owner , forKeyPath: AppConstants.photoEntityOwner)
        newCachedImage.setValue(photo.secret , forKeyPath: AppConstants.photoEntitySecret)
        newCachedImage.setValue(photo.server , forKeyPath: AppConstants.photoEntityServer)
        newCachedImage.setValue(photo.title , forKeyPath: AppConstants.photoEntityTitle)
        newCachedImage.setValue(photo.imagePath(), forKey: AppConstants.photoEntityImagePath)
        do {
            try persistentContainer.viewContext.save()
        } catch {
            throw error
        }
    }
    
    
    private func saveImage(image: UIImage, key: String) throws {
        if let entity = NSEntityDescription.entity(forEntityName: AppConstants.coreDataImageEntity, in: persistentContainer.viewContext) {
            let newCachedImage = NSManagedObject(entity: entity, insertInto: persistentContainer.viewContext)
            
            if let imageData = image.pngData() {
                newCachedImage.setValue(imageData, forKeyPath: key)
                do {
                    try persistentContainer.viewContext.save()
                } catch {
                    print("Failed to save image to Core Data: \(error.localizedDescription)")
                    throw error
                }
            }
        }
    }
    
    //MARK: Load
    private func loadImage(with key: String) throws -> UIImage? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.coreDataImageEntity)
        
        do {
            if let result = try persistentContainer.viewContext.fetch(fetchRequest).first as? NSManagedObject {
                if let imageData = result.value(forKey: key) as? Data {
                    if let image = UIImage(data: imageData) {
                        return image
                    }
                }
            }
        } catch {
            print("Failed to fetch image from Core Data: \(error.localizedDescription)")
            throw error
        }
        return nil
    }
    
    
    
    private func loadPhoto(_ photo: Photo) throws -> Photo? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: AppConstants.coreDataPhotoEntity)
        fetchRequest.predicate = NSPredicate(format: "\(AppConstants.photoEntityID) == %@", photo.id as CVarArg)
        fetchRequest.fetchLimit = 1
        do {
            let result = try persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            if let managedObject = result?.first {
                let photo = Photo(id: managedObject.value(forKey: AppConstants.photoEntityID) as? String ?? "",
                                  owner: managedObject.value(forKey: AppConstants.photoEntityOwner) as? String ?? "",
                                  secret: managedObject.value(forKey: AppConstants.photoEntitySecret) as? String ?? "",
                                  server: managedObject.value(forKey: AppConstants.photoEntityServer) as? String ?? "",
                                  farm: managedObject.value(forKey: AppConstants.photoEntityFarm) as? Int ?? 0,
                                  title: managedObject.value(forKey: AppConstants.photoEntityTitle) as? String ?? "",
                                  ispublic: managedObject.value(forKey: AppConstants.photoEntityIsPublic) as? Int ?? 0,
                                  isfriend: managedObject.value(forKey: AppConstants.photoEntityIsFriend) as? Int ?? 0,
                                  isfamily: managedObject.value(forKey: AppConstants.photoEntityIsFamily) as? Int ?? 0)
                
                return photo
            }
            return nil
        } catch {
            throw error
        }
    }

    func getAllPhotos() throws -> [Photo] {
           let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: AppConstants.coreDataPhotoEntity)
           
           do {
               let results = try persistentContainer.viewContext.fetch(fetchRequest)
               var photos: [Photo] = []
               
               for result in results as? [NSManagedObject] ?? [] {
                   let photo = Photo(
                       id: result.value(forKey: AppConstants.photoEntityID) as? String ?? "",
                       owner: result.value(forKey: AppConstants.photoEntityOwner) as? String ?? "",
                       secret: result.value(forKey: AppConstants.photoEntitySecret) as? String ?? "",
                       server: result.value(forKey: AppConstants.photoEntityServer) as? String ?? "",
                       farm: result.value(forKey: AppConstants.photoEntityFarm) as? Int ?? 0,
                       title: result.value(forKey: AppConstants.photoEntityTitle) as? String ?? "",
                       ispublic: result.value(forKey: AppConstants.photoEntityIsPublic) as? Int ?? 0,
                       isfriend: result.value(forKey: AppConstants.photoEntityIsFriend) as? Int ?? 0,
                       isfamily: result.value(forKey: AppConstants.photoEntityIsFamily) as? Int ?? 0
                   )
                   photos.append(photo)
               }
               
               return photos
           } catch {
               throw error
           }
       }
    
    
    // MARK: Delete
    private func deletePhoto(_ photo: Photo) throws {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: AppConstants.coreDataPhotoEntity)
        fetchRequest.predicate = NSPredicate(format: "\(AppConstants.photoEntityID) ==  %@", photo.id)
        
        do {
            let photos = try persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            guard let photoToDelete = photos?.first else {
                return
            }
            persistentContainer.viewContext.delete(photoToDelete)
            try persistentContainer.viewContext.save()
        } catch {
            throw error
        }
    }

    
    private func deleteImage(with key: String) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: AppConstants.coreDataImageEntity)
        do {
            let results = try persistentContainer.viewContext.fetch(fetchRequest)
            for result in results {
                if let imageData = (result as AnyObject).value(forKey: key) as? Data {
                    if let _ = UIImage(data: imageData) {
                        persistentContainer.viewContext.delete(result as! NSManagedObject)
                    }
                }
            }
            
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete image from Core Data: \(error.localizedDescription)")
            throw error
        }
    }
    
    private func deleteAll() throws {
           let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: AppConstants.coreDataPhotoEntity)

           do {
               let results = try persistentContainer.viewContext.fetch(fetchRequest)
               for result in results {
                   if let photo = result as? NSManagedObject {
                       persistentContainer.viewContext.delete(photo)
                   }
               }
               try persistentContainer.viewContext.save()
           } catch {
               throw error
           }

           let imageFetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: AppConstants.coreDataImageEntity)

           do {
               let imageResults = try persistentContainer.viewContext.fetch(imageFetchRequest)
               for result in imageResults {
                   if let image = result as? NSManagedObject {
                       persistentContainer.viewContext.delete(image)
                   }
               }

               try persistentContainer.viewContext.save()
           } catch {
               throw error
           }
       }
}


extension CoreDataProvider: Persistable {
    func save<T>(object: T) throws {
        if let photo = object as? Photo {
            try savePhoto(photo)
            
        }
    }
    
    func getObject<T>(withID id: T) throws -> T? {
        guard let photo = id as? Photo else { return nil }
        if let photo = try loadPhoto(photo) {
            return photo as? T
        }
        return nil
    }
    
    func delete<T>(object: T) throws {
        if let photo = object as? Photo {
            try deletePhoto(photo)
        }
    }
    
    func getllObject<T>() throws -> [T]? {
        try getAllPhotos() as? [T]
    }
    
    func deleteAllObjects() throws {
        try deleteAll()
    }
    
}


